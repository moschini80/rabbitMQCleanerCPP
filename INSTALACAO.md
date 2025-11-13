# Guia de Instalação Rápida - RabbitMQ Cleaner C++

## 🚀 1 Linha - Instalação Automática

```powershell
irm https://raw.githubusercontent.com/moschini80/rabbitMQCleanerCPP/main/install.ps1 | iex
```

Pronto! Agora use:
```powershell
rabbitmq_cleaner.exe --help
```

---

## 📦 Download Manual

### Opção A: Releases do GitHub

```powershell
# Baixar última versão
$url = "https://github.com/moschini80/rabbitMQCleanerCPP/releases/latest/download/rabbitmq-cleaner-2.0.0-win64.zip"
Invoke-WebRequest -Uri $url -OutFile rabbitmq-cleaner.zip

# Extrair
Expand-Archive rabbitmq-cleaner.zip -DestinationPath C:\Tools\

# Usar
cd C:\Tools\rabbitmq-cleaner-2.0.0-win64\bin
.\rabbitmq_cleaner.exe --help
```

### Opção B: Git Clone + Compilar

```powershell
# Clonar repositório
git clone https://github.com/moschini80/rabbitMQCleanerCPP.git
cd rabbitMQCleanerCPP

# Compilar (requer MSYS2/MinGW)
C:\msys64\mingw64\bin\g++.exe -std=c++17 -O2 -o bin\rabbitmq_cleaner.exe src\main.cpp -lrabbitmq

# Copiar DLL
Copy-Item C:\msys64\mingw64\bin\librabbitmq-4.dll bin\
```

---

## 🥤 Gerenciadores de Pacotes

### Scoop (Recomendado)

```powershell
scoop bucket add moschini https://github.com/moschini80/scoop-bucket
scoop install rabbitmq-cleaner
```

Atualizar:
```powershell
scoop update rabbitmq-cleaner
```

### WinGet (Futuro)

```powershell
# Em breve
winget install RabbitMQCleaner
```

---

## 🔧 Adicionar ao PATH Manualmente

Se baixou manualmente, adicione ao PATH:

```powershell
# Temporário (apenas sessão atual)
$env:Path += ";C:\Tools\rabbitmq-cleaner-2.0.0-win64\bin"

# Permanente (todas as sessões)
$path = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$path;C:\Tools\rabbitmq-cleaner-2.0.0-win64\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
```

---

## ✅ Verificar Instalação

```powershell
rabbitmq_cleaner.exe --help
```

Deve mostrar:
```
Usage: rabbitmq_cleaner.exe [-v|--verbose] [-l|--loop] <amqp_url> <queue_name> <regex_pattern>

Example:
  rabbitmq_cleaner.exe amqp://guest:guest@localhost:5672/ myqueue "pattern.*"

Options:
  -v, --verbose    Enable verbose output
  -l, --loop       Loop forever (don't stop when first NACK message repeats)
```

---

## 🆘 Problemas Comuns

### "DLL não encontrada"
```powershell
# Copie a DLL para a mesma pasta do EXE
Copy-Item C:\msys64\mingw64\bin\librabbitmq-4.dll bin\
```

### "Comando não encontrado"
```powershell
# Adicione ao PATH ou use caminho completo
.\bin\rabbitmq_cleaner.exe --help
```

### Script de instalação bloqueado
```powershell
# Execute com bypass
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/moschini80/rabbitMQCleanerCPP/main/install.ps1 | iex"
```

---

## 📚 Mais Informações

- **Documentação completa**: [README.md](README.md)
- **Guia de uso**: [Exemplos no README](README.md#exemplos)
- **Publicação**: [PUBLICACAO.md](PUBLICACAO.md)
- **Issues**: https://github.com/moschini80/rabbitMQCleanerCPP/issues

---

## 🔄 Desinstalar

### Se instalou com script automático:
```powershell
Remove-Item -Path "$env:LOCALAPPDATA\Programs\RabbitMQCleaner" -Recurse -Force

# Remover do PATH manualmente em:
# Configurações do Windows > Sistema > Sobre > Configurações avançadas > Variáveis de Ambiente
```

### Se instalou com Scoop:
```powershell
scoop uninstall rabbitmq-cleaner
```

### Se instalou manualmente:
```powershell
# Simplesmente delete a pasta onde extraiu
Remove-Item -Path "C:\Tools\rabbitmq-cleaner-2.0.0-win64" -Recurse -Force
```
