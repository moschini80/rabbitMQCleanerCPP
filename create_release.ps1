# Script para criar release do RabbitMQ Cleaner
# Uso: .\create_release.ps1

$VERSION = "2.0.0"
$APP_NAME = "rabbitmq-cleaner"
$RELEASE_DIR = "release"
$RELEASE_NAME = "$APP_NAME-$VERSION-win64"

Write-Host "Creating release package for $APP_NAME v$VERSION..." -ForegroundColor Green

# Limpar e criar diretório de release
if (Test-Path $RELEASE_DIR) {
    Remove-Item -Path $RELEASE_DIR -Recurse -Force
}
New-Item -ItemType Directory -Path $RELEASE_DIR -Force | Out-Null

# Criar estrutura
$BIN_DIR = "$RELEASE_DIR\$RELEASE_NAME\bin"
New-Item -ItemType Directory -Path $BIN_DIR -Force | Out-Null

# Copiar executável e DLL
Write-Host "Copying executable and DLL..." -ForegroundColor Yellow
Copy-Item "bin\rabbitmq_cleaner.exe" "$BIN_DIR\"
Copy-Item "bin\librabbitmq-4.dll" "$BIN_DIR\"

# Copiar documentação
Write-Host "Copying documentation..." -ForegroundColor Yellow
Copy-Item "README.md" "$RELEASE_DIR\$RELEASE_NAME\"
Copy-Item "LICENSE" "$RELEASE_DIR\$RELEASE_NAME\" -ErrorAction SilentlyContinue

# Criar arquivo de versão
@"
RabbitMQ Cleaner C++ v$VERSION
================================

Para instalar via Scoop:
  scoop bucket add extras
  scoop install rabbitmq-cleaner

Para usar:
  .\bin\rabbitmq_cleaner.exe --help

Documentação completa: README.md
"@ | Out-File -FilePath "$RELEASE_DIR\$RELEASE_NAME\VERSION.txt" -Encoding UTF8

# Criar ZIP
Write-Host "Creating ZIP archive..." -ForegroundColor Yellow
$ZIP_PATH = "$RELEASE_DIR\$RELEASE_NAME.zip"
Compress-Archive -Path "$RELEASE_DIR\$RELEASE_NAME\*" -DestinationPath $ZIP_PATH -Force

# Calcular hash SHA256 para Scoop
Write-Host "`nCalculating SHA256 hash for Scoop manifest..." -ForegroundColor Green
$HASH = (Get-FileHash -Path $ZIP_PATH -Algorithm SHA256).Hash
Write-Host "SHA256: $HASH" -ForegroundColor Cyan

# Mostrar informações
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Release package created successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Package: $ZIP_PATH" -ForegroundColor Yellow
Write-Host "Size: $((Get-Item $ZIP_PATH).Length / 1KB) KB" -ForegroundColor Yellow
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Upload $RELEASE_NAME.zip to GitHub Releases" -ForegroundColor White
Write-Host "2. Update rabbitmq-cleaner.json with the SHA256 hash above" -ForegroundColor White
Write-Host "3. Create PR to scoop-extras bucket or your own bucket" -ForegroundColor White
Write-Host "`nOr simply distribute the ZIP file directly!" -ForegroundColor Green
