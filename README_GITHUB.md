# RabbitMQ Cleaner C++ 🐰

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)](https://github.com/moschini80/rabbitMQCleanerCPP)
[![C++](https://img.shields.io/badge/C%2B%2B-17-blue.svg)](https://isocpp.org/)

Ferramenta de linha de comando em C++ para limpar filas RabbitMQ usando filtros de expressões regulares.

## 🚀 Instalação Rápida

### Opção 1: Portátil (SEM instalação) ⭐

**Baixe e execute - não precisa instalar nada!**

1. [Download da última versão](https://github.com/moschini80/rabbitMQCleanerCPP/releases/latest) (ZIP)
2. Extraia para qualquer pasta
3. Execute: `.\bin\rabbitmq_cleaner.exe --help`

✅ 100% portátil • ✅ Sem admin • ✅ Roda de pendrive

---

### Opção 2: Instalação Automática (com PATH)

```powershell
irm https://raw.githubusercontent.com/moschini80/rabbitMQCleanerCPP/main/install.ps1 | iex
```

---

### Opção 3: Via Scoop (requer Scoop instalado)

```powershell
scoop bucket add moschini https://github.com/moschini80/scoop-bucket
scoop install rabbitmq-cleaner
```

## 📖 Uso Básico

```powershell
# Remover mensagens que dão match no regex
rabbitmq_cleaner.exe amqp://guest:guest@localhost:5672/ myqueue "error|warning"

# Modo verbose (ver conteúdo das mensagens)
rabbitmq_cleaner.exe -v amqp://user:pass@rabbitmq.local:5672/ logs "critical"

# Modo loop infinito (Ctrl+C para parar)
rabbitmq_cleaner.exe -l amqp://guest:guest@localhost:5672/ eventos "failed"
```

## ✨ Funcionalidades

- ✅ **ACK** mensagens que dão match no regex (remove da fila)
- ❌ **NACK** mensagens que não dão match (mantém na fila)
- 🔍 Filtros por regex ECMAScript
- 🔄 Detecção automática de loop
- 📊 Modo verbose para debugging
- 🔁 Modo loop infinito opcional
- 📦 Apenas 1 DLL necessária (portátil)

## 📚 Documentação

- [Guia Completo](README.md)
- [Instalação Detalhada](INSTALACAO.md)
- [Publicação](PUBLICACAO.md)

## 🛠️ Tecnologias

- **C++17**
- **rabbitmq-c** (biblioteca oficial MIT)
- **MinGW-w64 GCC**

## 📄 Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.
