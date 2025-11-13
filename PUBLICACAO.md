# Guia de Publicação - RabbitMQ Cleaner C++

Este guia mostra como publicar a aplicação em diferentes plataformas de distribuição.

## 📦 Opção 1: GitHub Releases (Mais Simples)

### Passo a passo:

1. **Criar pacote de release:**
   ```powershell
   .\create_release.ps1
   ```

2. **Criar repositório no GitHub:**
   - Acesse: https://github.com/new
   - Nome: `rabbitmq-cleaner-cpp`
   - Descrição: `C++ RabbitMQ message cleaner with regex filtering`
   - Público ou Privado conforme preferir

3. **Upload do código:**
   ```powershell
   git init
   git add .
   git commit -m "Initial release v2.0.0"
   git branch -M main
   git remote add origin https://github.com/SEU-USUARIO/rabbitmq-cleaner-cpp.git
   git push -u origin main
   ```

4. **Criar Release no GitHub:**
   - Acesse: `https://github.com/SEU-USUARIO/rabbitmq-cleaner-cpp/releases/new`
   - Tag version: `v2.0.0`
   - Release title: `RabbitMQ Cleaner C++ v2.0.0`
   - Description: Cole o conteúdo do README
   - Anexe o arquivo: `release\rabbitmq-cleaner-2.0.0-win64.zip`
   - Clique em "Publish release"

5. **Usuários podem instalar:**
   ```powershell
   # Download manual
   Invoke-WebRequest -Uri "https://github.com/SEU-USUARIO/rabbitmq-cleaner-cpp/releases/latest/download/rabbitmq-cleaner-2.0.0-win64.zip" -OutFile "rabbitmq-cleaner.zip"
   Expand-Archive rabbitmq-cleaner.zip -DestinationPath C:\Tools\
   ```

---

## 🥤 Opção 2: Scoop (Recomendado)

### Por que Scoop?
- ✅ Instalação com 1 comando: `scoop install rabbitmq-cleaner`
- ✅ Atualização automática: `scoop update rabbitmq-cleaner`
- ✅ Sem necessidade de admin
- ✅ Sem poluir PATH global

### Passo a passo:

1. **Complete a Opção 1 primeiro** (GitHub Releases)

2. **Atualize o hash no manifest:**
   - Execute: `.\create_release.ps1` (anote o SHA256)
   - Edite `rabbitmq-cleaner.json`:
     ```json
     "hash": "COLE-O-SHA256-AQUI"
     ```
   - Atualize a URL com seu usuário GitHub

3. **Opção A: Criar seu próprio bucket (mais fácil)**
   ```powershell
   # Criar repositório no GitHub: seu-usuario/scoop-bucket
   # Adicione o arquivo rabbitmq-cleaner.json nele
   
   # Usuários instalam com:
   scoop bucket add seu-nome https://github.com/SEU-USUARIO/scoop-bucket
   scoop install rabbitmq-cleaner
   ```

4. **Opção B: Publicar no bucket oficial (mais demorado)**
   - Fork: https://github.com/ScoopInstaller/Extras
   - Adicione `rabbitmq-cleaner.json` na pasta `bucket/`
   - Crie Pull Request
   - Aguarde aprovação (1-3 dias)
   
   Após aprovação:
   ```powershell
   scoop bucket add extras
   scoop install rabbitmq-cleaner
   ```

---

## 🍫 Opção 3: Chocolatey

### Passo a passo:

1. **Instalar Chocolatey CLI:**
   ```powershell
   choco install chocolatey
   ```

2. **Criar conta:** https://community.chocolatey.org/account/Register

3. **Criar pacote `.nuspec`:**
   ```xml
   <?xml version="1.0"?>
   <package>
     <metadata>
       <id>rabbitmq-cleaner</id>
       <version>2.0.0</version>
       <authors>Seu Nome</authors>
       <description>RabbitMQ message cleaner with regex filtering</description>
       <projectUrl>https://github.com/SEU-USUARIO/rabbitmq-cleaner-cpp</projectUrl>
       <licenseUrl>https://github.com/SEU-USUARIO/rabbitmq-cleaner-cpp/blob/main/LICENSE</licenseUrl>
       <tags>rabbitmq amqp messaging</tags>
     </metadata>
     <files>
       <file src="bin\**" target="tools" />
     </files>
   </package>
   ```

4. **Empacotar e publicar:**
   ```powershell
   choco pack
   choco push rabbitmq-cleaner.2.0.0.nupkg --source https://push.chocolatey.org/
   ```

5. **Usuários instalam:**
   ```powershell
   choco install rabbitmq-cleaner
   ```

---

## 🪟 Opção 4: WinGet (Microsoft Oficial)

### Passo a passo:

1. **Complete Opção 1** (GitHub Releases)

2. **Fork do repositório:**
   - Fork: https://github.com/microsoft/winget-pkgs

3. **Criar manifest:**
   ```powershell
   # Dentro do fork
   cd manifests\r\RabbitMQCleaner\
   mkdir 2.0.0
   ```

4. **Criar 3 arquivos YAML:**
   
   **RabbitMQCleaner.installer.yaml:**
   ```yaml
   PackageIdentifier: RabbitMQCleaner
   PackageVersion: 2.0.0
   Installers:
     - Architecture: x64
       InstallerType: zip
       InstallerUrl: https://github.com/SEU-USUARIO/rabbitmq-cleaner-cpp/releases/download/v2.0.0/rabbitmq-cleaner-2.0.0-win64.zip
       InstallerSha256: SHA256-HASH-AQUI
   ```

   **RabbitMQCleaner.locale.en-US.yaml:**
   ```yaml
   PackageIdentifier: RabbitMQCleaner
   PackageVersion: 2.0.0
   PackageLocale: en-US
   Publisher: Seu Nome
   PackageName: RabbitMQ Cleaner
   License: MIT
   ShortDescription: RabbitMQ message cleaner with regex filtering
   ```

   **RabbitMQCleaner.yaml:**
   ```yaml
   PackageIdentifier: RabbitMQCleaner
   PackageVersion: 2.0.0
   DefaultLocale: en-US
   ManifestType: version
   ManifestVersion: 1.0.0
   ```

5. **Criar Pull Request:**
   - Título: `New package: RabbitMQCleaner version 2.0.0`
   - Aguarde aprovação Microsoft (3-7 dias)

6. **Usuários instalam:**
   ```powershell
   winget install RabbitMQCleaner
   ```

---

## 🎯 Comparação

| Plataforma   | Facilidade | Aprovação | Popularidade | Recomendação |
|--------------|-----------|-----------|--------------|--------------|
| **GitHub Releases** | ⭐⭐⭐⭐⭐ | Imediato | ⭐⭐⭐ | 👍 Comece aqui |
| **Scoop** | ⭐⭐⭐⭐ | 1-2 dias | ⭐⭐⭐⭐ | 👍 Recomendado |
| **Chocolatey** | ⭐⭐⭐ | 2-5 dias | ⭐⭐⭐⭐⭐ | 💼 Ambiente corporativo |
| **WinGet** | ⭐⭐ | 3-7 dias | ⭐⭐⭐⭐⭐ | 🏢 Microsoft oficial |

---

## 🚀 Estratégia Recomendada

### Fase 1: Imediato (hoje)
1. ✅ Criar GitHub Releases
2. ✅ Distribuir ZIP diretamente

### Fase 2: Próximos dias
3. ✅ Publicar no Scoop (seu próprio bucket)
4. ✅ Criar PR para Scoop Extras

### Fase 3: Longo prazo
5. ⏳ Publicar no Chocolatey
6. ⏳ Publicar no WinGet

---

## 📝 Script de Instalação Manual

Para usuários sem gerenciadores de pacotes, crie `install.ps1`:

```powershell
# Quick installer for RabbitMQ Cleaner
$INSTALL_DIR = "$env:LOCALAPPDATA\Programs\RabbitMQCleaner"
$ZIP_URL = "https://github.com/SEU-USUARIO/rabbitmq-cleaner-cpp/releases/latest/download/rabbitmq-cleaner-2.0.0-win64.zip"

Write-Host "Installing RabbitMQ Cleaner..." -ForegroundColor Green
New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
Invoke-WebRequest -Uri $ZIP_URL -OutFile "$env:TEMP\rabbitmq-cleaner.zip"
Expand-Archive "$env:TEMP\rabbitmq-cleaner.zip" -DestinationPath $INSTALL_DIR -Force
Remove-Item "$env:TEMP\rabbitmq-cleaner.zip"

# Add to PATH
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$INSTALL_DIR\bin*") {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$INSTALL_DIR\bin", "User")
}

Write-Host "✓ Installed to: $INSTALL_DIR" -ForegroundColor Green
Write-Host "✓ Run: rabbitmq_cleaner.exe --help" -ForegroundColor Cyan
```

Usuários executam:
```powershell
irm https://raw.githubusercontent.com/SEU-USUARIO/rabbitmq-cleaner-cpp/main/install.ps1 | iex
```

---

## ✅ Checklist Final

Antes de publicar:

- [ ] Compilado e testado em ambiente limpo
- [ ] README.md completo e atualizado
- [ ] LICENSE incluído
- [ ] Versão no código e manifests consistente
- [ ] Release notes escritas
- [ ] Screenshots/GIFs de demonstração (opcional)
- [ ] GitHub repo criado e público

---

## 🆘 Suporte

Após publicação, crie:
- **GitHub Issues**: Para bugs e features
- **GitHub Discussions**: Para perguntas gerais
- **GitHub Wiki**: Para documentação estendida

---

Bom lançamento! 🚀
