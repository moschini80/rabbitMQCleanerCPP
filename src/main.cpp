#include <iostream>
#include <string>
#include <cstring>
#include <regex>
#include <rabbitmq-c/amqp.h>
#include <rabbitmq-c/tcp_socket.h>

// Global flag for verbose mode
bool g_verbose = false;
bool g_loop_forever = false;

struct AMQPUrl {
    std::string user;
    std::string password;
    std::string host;
    int port;
    std::string vhost;
};

class SimpleAMQPClient {
private:
    amqp_connection_state_t conn;
    AMQPUrl url;
    std::string queue_name;
    std::regex pattern;
    int message_count;
    std::string first_nack_message;
    bool has_first_nack;

public:
    SimpleAMQPClient(const AMQPUrl& u, const std::string& q, const std::string& regex_pattern)
        : url(u), queue_name(q), pattern(regex_pattern), message_count(0), 
          has_first_nack(false) {
        conn = amqp_new_connection();
    }

    ~SimpleAMQPClient() {
        if (conn) {
            amqp_channel_close(conn, 1, AMQP_REPLY_SUCCESS);
            amqp_connection_close(conn, AMQP_REPLY_SUCCESS);
            amqp_destroy_connection(conn);
        }
    }

    bool connect() {
        // Create TCP socket
        amqp_socket_t* socket = amqp_tcp_socket_new(conn);
        if (!socket) {
            std::cerr << "Error creating TCP socket" << std::endl;
            return false;
        }

        if (g_verbose) {
            std::cout << "[VERBOSE] Connecting to " << url.host << ":" << url.port << std::endl;
        }

        // Open socket
        int status = amqp_socket_open(socket, url.host.c_str(), url.port);
        if (status) {
            std::cerr << "Error opening TCP socket: " << status << std::endl;
            return false;
        }

        if (g_verbose) {
            std::cout << "[VERBOSE] Socket opened successfully" << std::endl;
        }

        // Login
        amqp_rpc_reply_t reply = amqp_login(
            conn,
            url.vhost.c_str(),
            0,           // channel_max (0 = no limit)
            131072,      // frame_max (128KB)
            0,           // heartbeat (0 = disabled)
            AMQP_SASL_METHOD_PLAIN,
            url.user.c_str(),
            url.password.c_str()
        );

        if (reply.reply_type != AMQP_RESPONSE_NORMAL) {
            std::cerr << "Error logging in to RabbitMQ" << std::endl;
            if (reply.reply_type == AMQP_RESPONSE_SERVER_EXCEPTION) {
                amqp_connection_close_t* m = (amqp_connection_close_t*)reply.reply.decoded;
                std::cerr << "Server error: " << m->reply_code << " - ";
                std::cerr.write((char*)m->reply_text.bytes, m->reply_text.len);
                std::cerr << std::endl;
            }
            return false;
        }

        if (g_verbose) {
            std::cout << "[VERBOSE] Logged in successfully" << std::endl;
        }

        // Open channel
        amqp_channel_open(conn, 1);
        reply = amqp_get_rpc_reply(conn);
        if (reply.reply_type != AMQP_RESPONSE_NORMAL) {
            std::cerr << "Error opening channel" << std::endl;
            return false;
        }

        if (g_verbose) {
            std::cout << "[VERBOSE] Channel opened successfully" << std::endl;
        }

        std::cout << "Connected successfully!" << std::endl;
        return true;
    }

    void consumeQueue() {
        std::cout << "Started consuming from queue: " << queue_name << std::endl;
        
        if (g_loop_forever) {
            std::cout << "⚠️  Loop mode enabled - Press Ctrl+C to stop" << std::endl;
        }

        // Set QoS - prefetch 1 message at a time
        amqp_basic_qos(conn, 1, 0, 1, 0);

        // Start consuming
        amqp_basic_consume(
            conn,
            1,                                              // channel
            amqp_cstring_bytes(queue_name.c_str()),        // queue
            amqp_empty_bytes,                              // consumer_tag
            0,                                              // no_local
            0,                                              // no_ack (manual ack)
            0,                                              // exclusive
            amqp_empty_table                               // arguments
        );

        amqp_rpc_reply_t reply = amqp_get_rpc_reply(conn);
        if (reply.reply_type != AMQP_RESPONSE_NORMAL) {
            std::cerr << "Error starting consumer" << std::endl;
            return;
        }

        if (g_verbose) {
            std::cout << "[VERBOSE] Consumer started, waiting for messages..." << std::endl;
        }

        // Consume messages
        while (true) {
            amqp_envelope_t envelope;
            amqp_maybe_release_buffers(conn);

            // Wait for message with timeout (1 second)
            struct timeval timeout;
            timeout.tv_sec = 1;
            timeout.tv_usec = 0;

            reply = amqp_consume_message(conn, &envelope, &timeout, 0);

            if (reply.reply_type == AMQP_RESPONSE_LIBRARY_EXCEPTION) {
                if (reply.library_error == AMQP_STATUS_TIMEOUT) {
                    if (g_verbose) {
                        std::cout << "[VERBOSE] No messages in queue, exiting..." << std::endl;
                    }
                    break;
                }
                if (reply.library_error == AMQP_STATUS_UNEXPECTED_STATE) {
                    // Connection closed
                    break;
                }
                std::cerr << "Error consuming message: " << amqp_error_string2(reply.library_error) << std::endl;
                break;
            }

            if (reply.reply_type != AMQP_RESPONSE_NORMAL) {
                std::cerr << "Error in consumer response" << std::endl;
                amqp_destroy_envelope(&envelope);
                break;
            }

            // Extract message body
            std::string message_body(
                (char*)envelope.message.body.bytes,
                envelope.message.body.len
            );

            if (g_verbose) {
                std::cout << "[VERBOSE] Received message (delivery_tag=" 
                         << envelope.delivery_tag << "):" << std::endl;
                std::cout << "[VERBOSE] Message length: " << message_body.length() << " bytes" << std::endl;
                std::cout << "[VERBOSE] Message content:\n" << message_body << std::endl;
                std::cout << "[VERBOSE] ===========================================" << std::endl;
            }

            // Check regex
            bool matches = std::regex_search(message_body, pattern);

            if (g_verbose) {
                std::cout << "[VERBOSE] Regex match result: " << (matches ? "YES" : "NO") << std::endl;
            }

            if (matches) {
                std::cout << "✓ Match found - ACK (removing from queue)" << std::endl;
                
                // ACK the message (remove from queue)
                int res = amqp_basic_ack(conn, 1, envelope.delivery_tag, 0);
                if (res != AMQP_STATUS_OK) {
                    std::cerr << "Error sending ACK" << std::endl;
                }
                message_count++;
            } else {
                // Check if this is the first NACK we're seeing again (loop detection by content)
                if (!g_loop_forever && has_first_nack && message_body == first_nack_message) {
                    std::cout << "\n⚠️  Detected loop: First NACKed message returned to front of queue" << std::endl;
                    std::cout << "   Stopping to avoid infinite loop." << std::endl;
                    
                    if (g_verbose) {
                        std::cout << "[VERBOSE] Loop detected with message: " << message_body.substr(0, 100) << "..." << std::endl;
                    }
                    
                    // NACK this message one last time to keep it in queue
                    amqp_basic_nack(conn, 1, envelope.delivery_tag, 0, 1);
                    amqp_destroy_envelope(&envelope);
                    break;
                }
                
                std::cout << "✗ No match - NACK (keeping in queue)" << std::endl;
                
                // Remember the first NACK message content
                if (!has_first_nack) {
                    first_nack_message = message_body;
                    has_first_nack = true;
                    
                    if (g_verbose) {
                        std::cout << "[VERBOSE] Marked first NACK message for loop detection" << std::endl;
                        std::cout << "[VERBOSE] First 100 chars: " << message_body.substr(0, 100) << std::endl;
                    }
                }
                
                // NACK with requeue=true (keep in queue)
                int res = amqp_basic_nack(conn, 1, envelope.delivery_tag, 0, 1);
                if (res != AMQP_STATUS_OK) {
                    std::cerr << "Error sending NACK" << std::endl;
                }
            }

            amqp_destroy_envelope(&envelope);
        }

        std::cout << "\nTotal processed: " << message_count << " messages" << std::endl;
    }
};

bool parseAMQPUrl(const std::string& url_str, AMQPUrl& url) {
    // Parse: amqp://user:password@host:port/vhost
    std::regex url_regex(R"(amqp://([^:]+):([^@]+)@([^:]+):(\d+)(/.*)?)");
    std::smatch match;
    
    if (!std::regex_match(url_str, match, url_regex)) {
        return false;
    }
    
    url.user = match[1].str();
    url.password = match[2].str();
    url.host = match[3].str();
    url.port = std::stoi(match[4].str());
    url.vhost = match[5].matched ? match[5].str().substr(1) : "/";
    
    if (url.vhost.empty()) {
        url.vhost = "/";
    }
    
    return true;
}

void printUsage(const char* prog_name) {
    std::cout << "Usage: " << prog_name << " [-v|--verbose] [-l|--loop] <amqp_url> <queue_name> <regex_pattern>" << std::endl;
    std::cout << "\nExample:" << std::endl;
    std::cout << "  " << prog_name << " amqp://guest:guest@localhost:5672/ myqueue \"pattern.*\"" << std::endl;
    std::cout << "\nOptions:" << std::endl;
    std::cout << "  -v, --verbose    Enable verbose output" << std::endl;
    std::cout << "  -l, --loop       Loop forever (don't stop when first NACK message repeats)" << std::endl;
}

int main(int argc, char* argv[]) {
    // Parse command line arguments
    int arg_offset = 1;
    
    // Parse flags
    while (arg_offset < argc && argv[arg_offset][0] == '-') {
        std::string flag = argv[arg_offset];
        if (flag == "-v" || flag == "--verbose") {
            g_verbose = true;
        } else if (flag == "-l" || flag == "--loop") {
            g_loop_forever = true;
        } else {
            std::cerr << "Unknown option: " << flag << std::endl;
            printUsage(argv[0]);
            return 1;
        }
        arg_offset++;
    }
    
    if (argc < arg_offset + 3) {
        printUsage(argv[0]);
        return 1;
    }
    
    std::string amqp_url = argv[arg_offset];
    std::string queue_name = argv[arg_offset + 1];
    std::string regex_pattern = argv[arg_offset + 2];
    
    // Parse URL
    AMQPUrl url;
    if (!parseAMQPUrl(amqp_url, url)) {
        std::cerr << "Invalid AMQP URL format" << std::endl;
        std::cerr << "Expected: amqp://user:password@host:port/vhost" << std::endl;
        return 1;
    }
    
    if (g_verbose) {
        std::cout << "[VERBOSE] Configuration:" << std::endl;
        std::cout << "  Host: " << url.host << ":" << url.port << std::endl;
        std::cout << "  User: " << url.user << std::endl;
        std::cout << "  VHost: " << url.vhost << std::endl;
        std::cout << "  Queue: " << queue_name << std::endl;
        std::cout << "  Regex: " << regex_pattern << std::endl;
        std::cout << "  Loop forever: " << (g_loop_forever ? "YES" : "NO") << std::endl;
    }
    
    // Create client and connect
    try {
        SimpleAMQPClient client(url, queue_name, regex_pattern);
        
        if (!client.connect()) {
            std::cerr << "Failed to connect to RabbitMQ" << std::endl;
            return 1;
        }
        
        // Start consuming
        client.consumeQueue();
        
    } catch (const std::regex_error& e) {
        std::cerr << "Invalid regex pattern: " << e.what() << std::endl;
        return 1;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}
