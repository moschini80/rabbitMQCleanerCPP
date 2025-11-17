# RabbitMQ Cleaner C++ 2.0

Aplicação em C++ para processar mensagens de filas RabbitMQ usando filtros de expressões regulares (regex).

## Descrição

Esta aplicação conecta-se a um servidor RabbitMQ via AMQP, lê mensagens de uma fila específica e processa cada mensagem de acordo com um padrão regex fornecido:

- **Mensagens que correspondem ao regex**: São confirmadas com ACK (removidas da fila)
- **Mensagens que NÃO correspondem ao regex**: São rejeitadas com NACK e recolocadas na fila (mantidas)

## Funcionalidades

- ✅ Usa biblioteca oficial **rabbitmq-c** (licença MIT)
- ✅ Parse de URL AMQP completo
- ✅ Filtro de mensagens por regex ECMAScript
- ✅ ACK/NACK seletivo de mensagens
- ✅ **Detecção automática de loop** (para quando a primeira mensagem NACKed retorna)
- ✅ **Modo verbose** para debugging
- ✅ **Modo loop infinito** opcional
- ✅ Apenas **1 DLL necessária** (librabbitmq-4.dll) - pacote portátil
- ✅ Relatório de processamento

## Requisitos

- **Windows**: MSYS2 com MinGW-w64 GCC
- **Biblioteca**: rabbitmq-c (incluída via MSYS2)
- Servidor RabbitMQ em execução

## Instalação

### � **Uso Portátil - SEM Instalação** (Mais Simples) ⭐

**Não precisa instalar nada! Apenas baixe e execute:**

1. **Baixar do GitHub:**
   - Acesse: https://github.com/moschini80/rabbitMQCleanerCPP/releases/latest
   - Clique em: `rabbitmq-cleaner-2.0.0-win64.zip` para baixar

2. **Extrair para qualquer lugar:**
   ```powershell
   # Extrair para onde quiser (até pendrive funciona!)
   Expand-Archive rabbitmq-cleaner-2.0.0-win64.zip -DestinationPath C:\MeusProgramas\
   ```

3. **Executar diretamente:**
   ```powershell
   cd C:\MeusProgramas\rabbitmq-cleaner-2.0.0-win64\bin
   .\rabbitmq_cleaner.exe --help
   ```

✅ **100% Portátil** - Funciona de qualquer pasta  
✅ **Sem Admin** - Não precisa de permissões especiais  
✅ **Sem Instalação** - Apenas EXE + 1 DLL  
✅ **Roda de Pendrive** - Leve para qualquer Windows  

---

### 🚀 Instalação Automática (Com PATH)

Se quiser que fique disponível de qualquer lugar no terminal:

```powershell
irm https://raw.githubusercontent.com/moschini80/rabbitMQCleanerCPP/main/install.ps1 | iex
```

Isso vai:
1. ✅ Baixar a última versão automaticamente
2. ✅ Extrair para `%LOCALAPPDATA%\Programs\RabbitMQCleaner`
3. ✅ Adicionar ao PATH automaticamente
4. ✅ Pronto para usar: `rabbitmq_cleaner.exe --help` (de qualquer pasta)

---

### 🥤 Via Scoop (Gerenciador de Pacotes - Opcional)

**⚠️ Requer Scoop instalado:** https://scoop.sh/

```powershell
scoop bucket add moschini https://github.com/moschini80/scoop-bucket
scoop install rabbitmq-cleaner
```

**Vantagens:** Atualizações automáticas com `scoop update`

---

### 🔨 Compilar do Zero (Desenvolvedores)

#### 1. Instalar MSYS2 e ferramentas

```powershell
# Instalar MSYS2
winget install msys2.msys2

# Instalar GCC e rabbitmq-c
C:\msys64\usr\bin\pacman.exe -S mingw-w64-x86_64-gcc mingw-w64-x86_64-rabbitmq-c
```

#### 2. Compilar

```powershell
C:\msys64\mingw64\bin\g++.exe -std=c++17 -O2 -o bin\rabbitmq_cleaner.exe src\main.cpp -lrabbitmq
```

#### 3. Copiar DLL (para pacote portátil)

```powershell
Copy-Item C:\msys64\mingw64\bin\librabbitmq-4.dll bin\
```

Agora você pode distribuir a pasta `bin\` com o executável e a DLL! 📦

## Uso

```bash
rabbitmq_cleaner [opções] <amqp_url> <queue_name> <regex_pattern>
```

### Opções

- `-v` ou `--verbose`: Ativa modo detalhado (mostra conteúdo das mensagens e debug)
- `-l` ou `--loop`: Modo loop infinito (não para quando mensagem repetir, requer **Ctrl+C** para encerrar)

### Parâmetros

1. **amqp_url**: URL de conexão AMQP no formato `amqp://usuario:senha@host:porta/vhost`
2. **queue_name**: Nome da fila RabbitMQ a ser processada
3. **regex_pattern**: Expressão regular ECMAScript para filtrar mensagens

### Exemplos

#### Exemplo 1: Processar fila local (para automaticamente)
```powershell
.\bin\rabbitmq_cleaner.exe amqp://guest:guest@localhost:5672/ minha_fila "error|erro"
```

#### Exemplo 2: Modo verbose para ver mensagens
```powershell
.\bin\rabbitmq_cleaner.exe -v amqp://guest:guest@172.1.100.40:5672/ logs "critical"
```

#### Exemplo 3: Modo loop infinito (necessário Ctrl+C para parar)
```powershell
.\bin\rabbitmq_cleaner.exe -l amqp://user:pass@rabbitmq.local:5672/ eventos "status.*failed"
```

#### Exemplo 4: Combinar verbose + loop
```powershell
.\bin\rabbitmq_cleaner.exe -v -l amqp://guest:guest@localhost:5672/ queue "pattern"
```

#### Exemplo 5: Filtrar emails específicos
```powershell
.\bin\rabbitmq_cleaner.exe -v amqp://guest:guest@172.1.100.40:5672/ HS.BadMail "to=<faturaporemail@suaempresa"
```

## Formato da URL AMQP

```
amqp://[usuario]:[senha]@[host]:[porta]/[vhost]
```

- **usuario**: Nome de usuário do RabbitMQ (padrão: guest)
- **senha**: Senha do RabbitMQ (padrão: guest)
- **host**: Endereço do servidor RabbitMQ
- **porta**: Porta AMQP (padrão: 5672)
- **vhost**: Virtual host (padrão: /)

### Exemplos de URLs válidas:
```
amqp://guest:guest@localhost:5672/
amqp://admin:senha@rabbitmq.local:5672/producao
amqp://user:pass@10.0.0.5:5672/dev
```

## Regex ECMAScript

A aplicação usa **regex ECMAScript** (similar a JavaScript/Perl). Principais operadores:

- `.` = qualquer caractere (exceto `\n`)
- `.*` = zero ou mais de qualquer caractere
- `\d` = dígito (0-9)
- `\w` = letra, dígito ou underscore
- `\s` = espaço em branco
- `^` = início da string
- `$` = fim da string
- `|` = OU lógico
- `()` = grupo de captura
- `[]` = classe de caracteres
- `\.` = ponto literal (escape)

### Exemplos de regex:

```
"error|warning"                           # Busca "error" OU "warning"
"to=<.*@suaempresa\.com\.br>"       # Email específico
"status.*failed"                          # "status" seguido de "failed"
"\d{4}-\d{2}-\d{2}"                      # Data formato YYYY-MM-DD
"postmaster@smtp\d+\.exemplo\.com"       # Padrão de servidor SMTP
```

## Comportamento

### Modo Normal (sem `-l`)

1. Conecta ao RabbitMQ usando a URL fornecida
2. Abre um canal de comunicação
3. Começa a consumir mensagens da fila especificada
4. Para cada mensagem:
   - Verifica se o conteúdo corresponde ao regex
   - **MATCH**: Envia ACK (mensagem é removida da fila permanentemente) ✅
   - **NO MATCH**: Envia NACK com requeue=true (mensagem retorna à fila) ❌
5. **Para automaticamente** quando a primeira mensagem com NACK retornar (evita loop infinito)
6. Exibe um resumo ao final do processamento

### Modo Loop Infinito (com `-l`)

1. Funciona igual ao modo normal
2. **NÃO para** quando mensagens se repetem
3. Continua processando indefinidamente
4. **⚠️ Requer Ctrl+C para encerrar manualmente**
5. Útil para processar filas que recebem mensagens continuamente

## Saída Exemplo

### Modo Normal:
```
Connected successfully!
Started consuming from queue: minha_fila
✓ Match found - ACK (removing from queue)
✗ No match - NACK (keeping in queue)
✓ Match found - ACK (removing from queue)

⚠️  Detected loop: First NACKed message returned to front of queue
   Stopping to avoid infinite loop.

Total processed: 2 messages
```

### Modo Verbose:
```
[VERBOSE] Configuration:
  Host: 172.1.100.40:5672
  User: guest
  VHost: /
  Queue: HS.Duda.teste
  Regex: faturaporemail@suaEmpresa
  Loop forever: NO
[VERBOSE] Connecting to 172.1.100.40:5672
[VERBOSE] Socket opened successfully
[VERBOSE] Logged in successfully
[VERBOSE] Channel opened successfully
Connected successfully!
Started consuming from queue: HS.Duda.teste
[VERBOSE] Consumer started, waiting for messages...
[VERBOSE] Received message (delivery_tag=1):
[VERBOSE] Message length: 258 bytes
[VERBOSE] Message content:
Jul  3 13:16:01 PostFixSuaEmpresa postfix/smtp[82111]: to=<faturaporemail@suaEmpresa.com.br>
[VERBOSE] ===========================================
[VERBOSE] Regex match result: YES
✓ Match found - ACK (removing from queue)

Total processed: 1 messages
```

### Modo Loop Infinito:
```
Connected successfully!
Started consuming from queue: eventos
⚠️  Loop mode enabled - Press Ctrl+C to stop
✓ Match found - ACK (removing from queue)
✗ No match - NACK (keeping in queue)
✓ Match found - ACK (removing from queue)
... (continua indefinidamente até Ctrl+C)
```

## Observações Importantes

- A aplicação processa mensagens **uma por vez** (QoS prefetch = 1)
- Mensagens que recebem NACK são **recolocadas no início da fila**
- **Detecção de loop**: Para automaticamente quando a primeira mensagem NACKed retorna (exceto com `-l`)
- **Timeout**: Se não houver mensagens por 1 segundo, a aplicação encerra (modo normal)
- O regex é **case-sensitive** (diferencia maiúsculas/minúsculas)
- A aplicação usa biblioteca oficial **rabbitmq-c** (protocolo AMQP completo e testado)

## Pacote Portátil

Para criar um pacote portátil:

1. Compile a aplicação
2. Copie `librabbitmq-4.dll` para a pasta `bin\`
3. Distribua a pasta `bin\` completa

Agora pode executar em qualquer Windows sem instalar nada! 📦

## Estrutura do Projeto

```
rabbitMQCleanerCPP2.0/
├── README.md               # Este arquivo
├── COMO_COMPILAR.md        # Guia de compilação Windows
├── CMakeLists.txt          # Configuração CMake (opcional)
├── build.ps1               # Script PowerShell de build
├── build.bat               # Script Batch de build
├── bin/
│   ├── rabbitmq_cleaner.exe      # Executável compilado
│   └── librabbitmq-4.dll         # DLL necessária
└── src/
    ├── main.cpp            # Código-fonte principal
    └── main.cpp.old        # Versão anterior (backup)
```

## Dependências

- **rabbitmq-c**: Biblioteca oficial C do RabbitMQ (MIT License)
  - Site: https://github.com/alanxz/rabbitmq-c
  - Licença: MIT (100% livre para uso comercial e privado)
  - Apenas 1 DLL necessária: `librabbitmq-4.dll`

## Troubleshooting

### Erro: "Error opening TCP socket"
- Verifique se o RabbitMQ está rodando
- Teste conexão: `telnet host porta`

### Erro: "Error logging in to RabbitMQ"
- Verifique usuário e senha na URL
- Verifique permissões do usuário no RabbitMQ

### Regex não está funcionando
- Use modo verbose (`-v`) para ver o conteúdo das mensagens
- Teste o regex online: https://regex101.com/ (selecione ECMAScript)
- Lembre-se de fazer escape dos caracteres especiais: `\.` para ponto literal

### Aplicação não para (fica em loop)
- **Sem `-l`**: Isso não deveria acontecer, verifique se há mensagens sendo adicionadas continuamente
- **Com `-l`**: Comportamento esperado! Pressione **Ctrl+C** para parar

### DLL não encontrada
- Copie `C:\msys64\mingw64\bin\librabbitmq-4.dll` para a mesma pasta do executável

## Licença

Este projeto usa a biblioteca **rabbitmq-c** (MIT License) e é fornecido como está, para fins educacionais e comerciais.

## Autor

Eduardo Moschini de Souza

