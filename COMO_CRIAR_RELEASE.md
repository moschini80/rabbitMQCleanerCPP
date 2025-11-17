# 📦 Guia Passo a Passo - Criar Release no GitHub

## Passo 1: Acessar Página de Releases

A página já foi aberta automaticamente, ou acesse manualmente:
```
https://github.com/moschini80/rabbitMQCleanerCPP/releases/new
```

---

## Passo 2: Preencher Formulário de Release

Na página que abriu, preencha os campos:

### 🏷️ **Tag version** (obrigatório)
```
v2.0.0
```
- Clique em "Choose a tag"
- Digite: `v2.0.0`
- Clique em "Create new tag: v2.0.0 on publish"

### 📝 **Release title** (obrigatório)
```
RabbitMQ Cleaner C++ v2.0.0
```

### 📄 **Description** (recomendado)

Cole este texto:

```markdown
## 🐰 RabbitMQ Cleaner C++ - v2.0.0

Ferramenta de linha de comando para limpar filas RabbitMQ usando filtros de expressões regulares.

### ✨ Funcionalidades

- ✅ ACK mensagens que dão match no regex (remove da fila)
- ❌ NACK mensagens que não dão match (mantém na fila)
- 🔍 Filtros por regex ECMAScript
- 🔄 Detecção automática de loop
- 📊 Modo verbose (-v) para debugging
- 🔁 Modo loop infinito (-l) opcional
- 📦 100% Portátil - apenas EXE + 1 DLL (177 KB)

### 🚀 Instalação Rápida

**Opção 1: Download Portátil (sem instalação)**
1. Baixe o arquivo `rabbitmq-cleaner-2.0.0-win64.zip` abaixo
2. Extraia para qualquer pasta
3. Execute: `.\bin\rabbitmq_cleaner.exe --help`

**Opção 2: Instalação Automática**
```powershell
irm https://raw.githubusercontent.com/moschini80/rabbitMQCleanerCPP/main/install.ps1 | iex
```

### 📖 Uso Básico

```powershell
# Remover mensagens que dão match no regex
rabbitmq_cleaner.exe amqp://guest:guest@localhost:5672/ myqueue "error|warning"

# Modo verbose
rabbitmq_cleaner.exe -v amqp://user:pass@rabbitmq.local:5672/ logs "critical"

# Modo loop infinito (Ctrl+C para parar)
rabbitmq_cleaner.exe -l amqp://guest:guest@localhost:5672/ eventos "failed"
```

### 📚 Documentação

- [README Completo](https://github.com/moschini80/rabbitMQCleanerCPP/blob/main/README.md)
- [Guia de Instalação](https://github.com/moschini80/rabbitMQCleanerCPP/blob/main/INSTALACAO.md)

### 🛠️ Tecnologias

- C++17
- rabbitmq-c (biblioteca oficial MIT)
- MinGW-w64 GCC 15.2.0

### 📄 Licença

MIT License
```

---

## Passo 3: Anexar o Arquivo ZIP

### 📎 **Attach binaries**

1. Role até o final da página
2. Encontre a seção "Attach binaries by dropping them here or selecting them"
3. **Arraste ou clique para anexar:**
   ```
   C:\Users\eduardo.moschini\source\repos\rabbitMQCleanerCPP2.0\release\rabbitmq-cleaner-2.0.0-win64.zip
   ```
4. Aguarde o upload (177 KB - rápido!)
5. Verá: ✅ `rabbitmq-cleaner-2.0.0-win64.zip` anexado

---

## Passo 4: Publicar

### ✅ Opções finais:

- [ ] **Set as a pre-release** - NÃO marque (é uma release estável)
- [x] **Set as the latest release** - MARQUE (é a última versão)

### 🚀 Clique no botão verde:

```
Publish release
```

---

## ✅ Pronto! Release Criada

Após publicar, você verá:

1. **URL da release:** `https://github.com/moschini80/rabbitMQCleanerCPP/releases/tag/v2.0.0`
2. **Download direto do ZIP:** Disponível automaticamente
3. **Badge de release:** Aparece no repositório

---

## 🎯 Testando a Instalação

Agora os usuários podem:

### Download Direto:
```
https://github.com/moschini80/rabbitMQCleanerCPP/releases/latest
```

### Instalação Automática:
```powershell
irm https://raw.githubusercontent.com/moschini80/rabbitMQCleanerCPP/main/install.ps1 | iex
```

### Via Scoop (após criar bucket):
```powershell
scoop bucket add moschini https://github.com/moschini80/scoop-bucket
scoop install rabbitmq-cleaner
```

---

## 📝 Checklist Final

Após publicar a release:

- [x] Código enviado ao GitHub (`git push`)
- [ ] Release v2.0.0 criada
- [ ] ZIP anexado à release
- [ ] Script `install.ps1` testado
- [ ] README atualizado com link correto
- [ ] (Opcional) Criar bucket do Scoop

---

## 🆘 Problemas Comuns

### "Tag já existe"
- Use outra versão: `v2.0.1`, `v2.1.0`, etc.

### "Arquivo muito grande"
- GitHub aceita até 2GB (seu ZIP tem 177KB - ok!)

### "Não consigo anexar arquivo"
- Tente arrastar o arquivo diretamente para a caixa
- Ou clique em "selecting them" e escolha o arquivo

---

## 🎉 Após Publicar

Compartilhe seu projeto:

```markdown
# Instale com 1 comando:
irm https://raw.githubusercontent.com/moschini80/rabbitMQCleanerCPP/main/install.ps1 | iex

# Ou baixe: https://github.com/moschini80/rabbitMQCleanerCPP/releases
```

---

**Boa sorte com seu lançamento! 🚀**
