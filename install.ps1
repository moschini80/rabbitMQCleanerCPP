# RabbitMQ Cleaner - Instalador Automático
# Uso: irm https://raw.githubusercontent.com/moschini80/rabbitMQCleanerCPP/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

# Configuração
$REPO = "moschini80/rabbitMQCleanerCPP"
$APP_NAME = "RabbitMQ Cleaner"
$INSTALL_DIR = "$env:LOCALAPPDATA\Programs\RabbitMQCleaner"
$BIN_DIR = "$INSTALL_DIR\bin"

Write-Host "`n==================================" -ForegroundColor Cyan
Write-Host "  $APP_NAME - Instalador" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Detectar última versão
Write-Host "`n[1/5] Buscando última versão..." -ForegroundColor Yellow
try {
    $release = Invoke-RestMethod "https://api.github.com/repos/$REPO/releases/latest"
    $VERSION = $release.tag_name
    $ZIP_URL = ($release.assets | Where-Object { $_.name -like "*.zip" }).browser_download_url
    
    if (-not $ZIP_URL) {
        throw "Arquivo ZIP não encontrado na release"
    }
    
    Write-Host "   ✓ Versão encontrada: $VERSION" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Erro ao buscar release: $_" -ForegroundColor Red
    Write-Host "`nTentando URL direta..." -ForegroundColor Yellow
    $VERSION = "v2.0.0"
    $ZIP_URL = "https://github.com/$REPO/releases/download/$VERSION/rabbitmq-cleaner-2.0.0-win64.zip"
}

# Criar diretório de instalação
Write-Host "`n[2/5] Criando diretório de instalação..." -ForegroundColor Yellow
if (Test-Path $INSTALL_DIR) {
    Write-Host "   ! Removendo instalação anterior..." -ForegroundColor Yellow
    Remove-Item -Path $INSTALL_DIR -Recurse -Force
}
New-Item -ItemType Directory -Path $BIN_DIR -Force | Out-Null
Write-Host "   ✓ Diretório criado: $INSTALL_DIR" -ForegroundColor Green

# Baixar release
Write-Host "`n[3/5] Baixando $APP_NAME $VERSION..." -ForegroundColor Yellow
$ZIP_PATH = "$env:TEMP\rabbitmq-cleaner.zip"
try {
    Invoke-WebRequest -Uri $ZIP_URL -OutFile $ZIP_PATH -UseBasicParsing
    $size = [math]::Round((Get-Item $ZIP_PATH).Length / 1KB, 2)
    Write-Host "   ✓ Download completo ($size KB)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Erro ao baixar: $_" -ForegroundColor Red
    exit 1
}

# Extrair arquivos
Write-Host "`n[4/5] Extraindo arquivos..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $ZIP_PATH -DestinationPath $INSTALL_DIR -Force
    Remove-Item $ZIP_PATH -Force
    Write-Host "   ✓ Arquivos extraídos" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Erro ao extrair: $_" -ForegroundColor Red
    exit 1
}

# Adicionar ao PATH do usuário
Write-Host "`n[5/5] Configurando PATH..." -ForegroundColor Yellow
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$BIN_DIR*") {
    $NewPath = "$UserPath;$BIN_DIR"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
    $env:Path = "$env:Path;$BIN_DIR"  # Atualiza sessão atual
    Write-Host "   ✓ Adicionado ao PATH do usuário" -ForegroundColor Green
} else {
    Write-Host "   ✓ Já está no PATH" -ForegroundColor Green
}

# Verificar instalação
Write-Host "`n==================================" -ForegroundColor Cyan
Write-Host "  Instalação Concluída!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan

Write-Host "`nLocal: $INSTALL_DIR" -ForegroundColor White
Write-Host "`nPara usar:" -ForegroundColor Cyan
Write-Host "  rabbitmq_cleaner.exe --help" -ForegroundColor White
Write-Host "  rabbitmq_cleaner.exe -v amqp://guest:guest@localhost:5672/ myqueue ""pattern""" -ForegroundColor White

Write-Host "`nDocumentação:" -ForegroundColor Cyan
Write-Host "  https://github.com/$REPO" -ForegroundColor White

Write-Host "`n⚠️  Reinicie o terminal para carregar o PATH atualizado`n" -ForegroundColor Yellow
