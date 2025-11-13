# Script para instalar MinGW Portátil e Compilar
Write-Host "=== Instalador MinGW Portátil + Compilação ===" -ForegroundColor Cyan

$projectRoot = "c:\Users\eduardo.moschini\source\repos\rabbitMQCleanerCPP2.0"
$mingwDir = "$projectRoot\tools\mingw"
$downloadUrl = "https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/seh/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z/download"

# Criar diretório tools
if (-not (Test-Path "$projectRoot\tools")) {
    New-Item -ItemType Directory -Path "$projectRoot\tools" | Out-Null
}

# Verificar se já está instalado
if (Test-Path "$mingwDir\bin\g++.exe") {
    Write-Host "MinGW já instalado em: $mingwDir" -ForegroundColor Green
} else {
    Write-Host "MinGW não encontrado. Você pode instalar de forma automática ou manual." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "OPÇÃO 1 - Instalação Automática via winget (Recomendado):" -ForegroundColor Cyan
    Write-Host "  Execute em um terminal COM PERMISSÕES DE ADMINISTRADOR:" -ForegroundColor White
    Write-Host "  winget install MSYS2.MSYS2" -ForegroundColor Yellow
    Write-Host "  Depois execute: C:\msys64\msys2_shell.cmd -mingw64" -ForegroundColor Yellow
    Write-Host "  Dentro do MSYS2: pacman -S mingw-w64-x86_64-gcc" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "OPÇÃO 2 - Download Manual (Mais simples):" -ForegroundColor Cyan
    Write-Host "  1. Acesse: https://winlibs.com/" -ForegroundColor White
    Write-Host "  2. Baixe: 'GCC ... Win64 - with POSIX threads'" -ForegroundColor White
    Write-Host "  3. Extraia o ZIP em: $projectRoot\tools\" -ForegroundColor White
    Write-Host "  4. Execute este script novamente" -ForegroundColor White
    Write-Host ""
    Write-Host "OPÇÃO 3 - TDM-GCC (Instalador Windows):" -ForegroundColor Cyan
    Write-Host "  1. Acesse: https://jmeubank.github.io/tdm-gcc/" -ForegroundColor White
    Write-Host "  2. Baixe e instale o TDM-GCC" -ForegroundColor White
    Write-Host "  3. Adicione ao PATH: C:\TDM-GCC-64\bin" -ForegroundColor White
    Write-Host ""
    
    $choice = Read-Host "Deseja que eu tente compilar online? (s/n)"
    if ($choice -eq 's' -or $choice -eq 'S') {
        Write-Host "`nCompilando online com Godbolt Compiler Explorer..." -ForegroundColor Yellow
        Write-Host "Esta é uma solução temporária. Para uso real, instale um compilador local." -ForegroundColor Gray
        
        # Criar script que usa compilador online (limitado)
        Write-Host "`nPor limitações de segurança, não é possível compilar executáveis completos online." -ForegroundColor Red
        Write-Host "Por favor, escolha uma das opções de instalação acima." -ForegroundColor Yellow
        exit 1
    } else {
        exit 1
    }
}

# Se chegou aqui, MinGW está instalado - compilar!
Write-Host "`n=== Compilando com MinGW ===" -ForegroundColor Cyan

$gccPath = "$mingwDir\bin\g++.exe"
if (-not (Test-Path $gccPath)) {
    # Procurar em outros locais comuns
    $possiblePaths = @(
        "C:\msys64\mingw64\bin\g++.exe",
        "C:\mingw64\bin\g++.exe",
        "C:\TDM-GCC-64\bin\g++.exe",
        "$projectRoot\tools\mingw64\bin\g++.exe"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            $gccPath = $path
            Write-Host "Compilador encontrado em: $gccPath" -ForegroundColor Green
            break
        }
    }
}

if (Test-Path $gccPath) {
    # Compilar
    $sourceFile = "$projectRoot\src\main.cpp"
    $outputDir = "$projectRoot\bin"
    $outputExe = "$outputDir\rabbitmq_cleaner.exe"
    
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir | Out-Null
    }
    
    Write-Host "Compilando: $sourceFile" -ForegroundColor Yellow
    Write-Host "Saída: $outputExe" -ForegroundColor Yellow
    
    & $gccPath -std=c++17 -O2 -o $outputExe $sourceFile -lws2_32
    
    if ($LASTEXITCODE -eq 0 -and (Test-Path $outputExe)) {
        Write-Host "`n========================================" -ForegroundColor Green
        Write-Host "BUILD CONCLUÍDO COM SUCESSO!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "Executável: $outputExe" -ForegroundColor Cyan
        Write-Host "`nUso:" -ForegroundColor Yellow
        Write-Host "  .\bin\rabbitmq_cleaner.exe amqp://guest:guest@localhost:5672/ fila `"regex`"" -ForegroundColor White
    } else {
        Write-Host "`nErro na compilação!" -ForegroundColor Red
    }
} else {
    Write-Host "`nCompilador não encontrado!" -ForegroundColor Red
    Write-Host "Instale usando uma das opções acima e tente novamente." -ForegroundColor Yellow
}
