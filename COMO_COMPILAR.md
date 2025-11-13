# Como Compilar o RabbitMQ Cleaner no Windows (SEM Visual Studio)

## Compilação Rápida com GCC/MinGW (Opensource)

### ✅ Método Recomendado: MSYS2 + MinGW-w64

Este é o método mais simples e rápido para compilar no Windows usando ferramentas **100% opensource e gratuitas**.

#### Passo 1: Instalar MSYS2 (Uma única linha!)

Abra o PowerShell e execute:

```powershell
winget install MSYS2.MSYS2
```

Aguarde a instalação completar (leva 1-2 minutos).

#### Passo 2: Instalar o GCC (Compilador C++ Opensource)

Após instalar o MSYS2, execute:

```powershell
C:\msys64\usr\bin\bash.exe -lc "pacman -Sy --noconfirm mingw-w64-x86_64-gcc"
```

Aguarde o download e instalação do GCC (pode levar 2-3 minutos).

#### Passo 3: Compilar a Aplicação

No diretório do projeto, execute:

```powershell
C:\msys64\mingw64\bin\g++.exe -std=c++17 -O2 -o bin\rabbitmq_cleaner.exe src\main.cpp -lws2_32
```

✅ **Pronto!** O executável estará em `bin\rabbitmq_cleaner.exe`

#### Passo 4: Testar

```powershell
.\bin\rabbitmq_cleaner.exe amqp://guest:guest@localhost:5672/ minha_fila "error"
```

---

## Alternativa: Script Automático

Você pode usar o script PowerShell que detecta automaticamente o compilador:

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

O script tentará encontrar GCC, MinGW ou outros compiladores instalados no sistema.

---

## Outras Opções de Compilação (Caso prefira)

### Opção 2: Visual Studio 2022 (Proprietário, mas gratuito)

1. **Instalar componentes C++** no Visual Studio 2022 Professional:
   - Abra o Visual Studio Installer
   - Clique em "Modificar" no VS 2022 Professional
   - Selecione "Desenvolvimento para desktop com C++"
   - Clique em "Modificar" para instalar

2. **Após a instalação**, execute:
   ```powershell
   powershell -ExecutionPolicy Bypass -File build.ps1
   ```

### Opção 3: MinGW-w64 Portátil (Download Manual)

1. **Baixar MinGW-w64**:
   - Acesse: https://winlibs.com/
   - Baixe a versão "GCC ... Win64 - with POSIX threads"
   - Extraia para `C:\mingw64`

2. **Compilar**:
   ```powershell
   C:\mingw64\bin\g++.exe -std=c++17 -O2 -o bin\rabbitmq_cleaner.exe src\main.cpp -lws2_32
   ```

### Opção 4: TDM-GCC (Instalador Windows Amigável)

1. **Instalar TDM-GCC**:
   - Acesse: https://jmeubank.github.io/tdm-gcc/
   - Baixe e execute o instalador
   - Instale na pasta padrão

2. **Compilar**:
   ```powershell
   C:\TDM-GCC-64\bin\g++.exe -std=c++17 -O2 -o bin\rabbitmq_cleaner.exe src\main.cpp -lws2_32
   ```

### Opção 5: Chocolatey + MinGW

1. **Instalar Chocolatey** (se não tiver):
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

2. **Instalar MinGW**:
   ```powershell
   choco install mingw
   ```

3. **Compilar**:
   ```powershell
   g++ -std=c++17 -O2 -o bin\rabbitmq_cleaner.exe src\main.cpp -lws2_32
   ```

---

## Compilador Utilizado no Build de Sucesso

Este projeto foi compilado com sucesso usando:
- **GCC 15.2.0** (Rev8, Built by MSYS2 project)
- **MSYS2/MinGW-w64** - Totalmente opensource
- **Sistema:** Windows 11
- **Data:** 11/11/2025

### Comando exato usado:
```powershell
C:\msys64\mingw64\bin\g++.exe -std=c++17 -O2 -o bin\rabbitmq_cleaner.exe src\main.cpp -lws2_32
```

### Verificação do build:
```powershell
PS> Test-Path bin\rabbitmq_cleaner.exe
True

PS> .\bin\rabbitmq_cleaner.exe
Usage: rabbitmq_cleaner.exe <amqp_url> <queue_name> <regex_pattern>
```

## Compilação Manual (Qualquer Opção)

Se preferir compilar manualmente após instalar um compilador:

```powershell
# Criar diretório de saída
mkdir bin

# Com GCC/MinGW:
g++ -std=c++17 -O2 -o bin\rabbitmq_cleaner.exe src\main.cpp -lws2_32

# Ou com Visual Studio C++ (cl.exe):
cl.exe /std:c++17 /EHsc /W3 /O2 /Fe:bin\rabbitmq_cleaner.exe src\main.cpp ws2_32.lib
```

## Script Automático

Após instalar qualquer compilador acima, simplesmente execute:

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

O script `build.ps1` detectará automaticamente qual compilador está disponível e compilará o projeto.

## Verificação Pós-Compilação

Após compilar com sucesso, você verá:

```
========================================
BUILD CONCLUÍDO COM SUCESSO!
========================================
Executável criado em: c:\Users\eduardo.moschini\source\repos\rabbitMQCleanerCPP2.0\bin\rabbitmq_cleaner.exe
```

## Uso do Executável

```powershell
.\bin\rabbitmq_cleaner.exe amqp://guest:guest@localhost:5672/ minha_fila "error|warning"
```

## Solução de Problemas

### "g++ não é reconhecido"
- Use o caminho completo: `C:\msys64\mingw64\bin\g++.exe`
- Ou adicione ao PATH: `$env:Path += ";C:\msys64\mingw64\bin"`
- Reinicie o PowerShell após instalar

### "winget não encontrado"
- Atualize o Windows para versão mais recente
- Instale o "App Installer" da Microsoft Store
- Ou baixe MSYS2 manualmente de: https://www.msys2.org/

### Erros de compilação
- Certifique-se de estar usando C++17 ou superior
- Verifique se todos os arquivos estão presentes: `src\main.cpp`
- Verifique se está no diretório correto do projeto

### Build lento
- Use `-O0` em vez de `-O2` para compilação mais rápida (menos otimizada)
- Exemplo: `g++ -std=c++17 -O0 -o bin\rabbitmq_cleaner.exe src\main.cpp -lws2_32`

---

## Vantagens do MSYS2/MinGW sobre Visual Studio

✅ **Opensource:** 100% código aberto  
✅ **Leve:** ~500MB vs ~7GB do Visual Studio  
✅ **Rápido:** Instalação em minutos  
✅ **Portátil:** Pode ser movido entre máquinas  
✅ **Multiplataforma:** Mesmo compilador usado em Linux  
✅ **Sem registro:** Não requer conta Microsoft  
✅ **Atualizado:** GCC 15.2 é mais recente que MSVC  

---

## Por que NÃO usar Visual Studio para este projeto?

Este projeto é uma aplicação C++ simples e **não precisa** das ferramentas pesadas do Visual Studio:

- ❌ Não usa bibliotecas específicas da Microsoft
- ❌ Não precisa de IDE gráfica
- ❌ Não usa recursos exclusivos do Windows
- ✅ Código portátil e compatível com GCC/Clang
- ✅ Compila em poucos segundos com GCC

**Conclusão:** Use ferramentas opensource! São mais leves, rápidas e adequadas para este tipo de projeto.
