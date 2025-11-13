cmake_minimum_required(VERSION 3.15)
project(RabbitMQCleaner VERSION 2.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find required packages
find_package(Threads REQUIRED)

# Add executable
add_executable(rabbitmq_cleaner
    src/main.cpp
)

# Link libraries
target_link_libraries(rabbitmq_cleaner 
    PRIVATE 
    Threads::Threads
)

# Add include directories
target_include_directories(rabbitmq_cleaner PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)

# For Windows specific settings
if(WIN32)
    target_link_libraries(rabbitmq_cleaner PRIVATE ws2_32)
endif()

# AMQP-CPP library (you'll need to install this or add as submodule)
# Option 1: If installed system-wide
# find_package(amqp-cpp REQUIRED)
# target_link_libraries(rabbitmq_cleaner PRIVATE amqp-cpp)

# Option 2: If using vcpkg
# Use: vcpkg install amqp-cpp
# And add to target_link_libraries

# Set output directory
set_target_properties(rabbitmq_cleaner PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
