# Script de build PowerShell para RabbitMQ Cleaner
Write-Host "=== RabbitMQ Cleaner - Build Script ===" -ForegroundColor Cyan

$projectRoot = "c:\Users\eduardo.moschini\source\repos\rabbitMQCleanerCPP2.0"
$sourceFile = "$projectRoot\src\main.cpp"
$outputDir = "$projectRoot\bin"
$outputExe = "$outputDir\rabbitmq_cleaner.exe"

# Cria diretório de saída
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
    Write-Host "Diretório bin criado" -ForegroundColor Green
}

# Tenta encontrar compiladores disponíveis
Write-Host "`nProcurando compiladores disponíveis..." -ForegroundColor Yellow

# Opção 1: Procurar cl.exe (Visual Studio)
$vsInstallations = @(
    "C:\Program Files\Microsoft Visual Studio\2022\Professional",
    "C:\Program Files\Microsoft Visual Studio\2022\Community",
    "C:\Program Files\Microsoft Visual Studio\2022\Enterprise",
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional",
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community"
)

$clPath = $null
foreach ($vsPath in $vsInstallations) {
    if (Test-Path $vsPath) {
        $found = Get-ChildItem $vsPath -Recurse -Filter "cl.exe" -ErrorAction SilentlyContinue | 
                 Where-Object { $_.FullName -match "VC\\Tools\\MSVC" } | 
                 Select-Object -First 1
        if ($found) {
            $clPath = $found.FullName
            $vcToolsDir = Split-Path (Split-Path (Split-Path (Split-Path $clPath)))
            Write-Host "Encontrado Visual Studio C++: $clPath" -ForegroundColor Green
            break
        }
    }
}

# Opção 2: MinGW/GCC
$gccPath = $null
$gccPossiblePaths = @(
    "C:\MinGW\bin\g++.exe",
    "C:\msys64\mingw64\bin\g++.exe",
    "C:\TDM-GCC-64\bin\g++.exe"
)

if (-not $clPath) {
    foreach ($path in $gccPossiblePaths) {
        if (Test-Path $path) {
            $gccPath = $path
            Write-Host "Encontrado GCC: $gccPath" -ForegroundColor Green
            break
        }
    }
    
    # Tenta encontrar g++ no PATH
    if (-not $gccPath) {
        try {
            $gccTest = Get-Command g++ -ErrorAction SilentlyContinue
            if ($gccTest) {
                $gccPath = $gccTest.Source
                Write-Host "Encontrado GCC no PATH: $gccPath" -ForegroundColor Green
            }
        } catch {}
    }
}

# Compilar com o que encontramos
Write-Host "`nIniciando compilação..." -ForegroundColor Yellow

if ($clPath) {
    Write-Host "Usando MSVC (Visual Studio C++)" -ForegroundColor Cyan
    
    # Configura variáveis de ambiente necessárias
    $vcToolsDir = (Get-Item $clPath).Directory.Parent.Parent.Parent.FullName
    $env:INCLUDE = "$vcToolsDir\include"
    $env:LIB = "$vcToolsDir\lib\x64"
    
    # Adiciona Windows SDK
    $sdkPath = "C:\Program Files (x86)\Windows Kits\10"
    if (Test-Path $sdkPath) {
        $sdkVersion = Get-ChildItem "$sdkPath\Include" | Sort-Object Name -Descending | Select-Object -First 1 -ExpandProperty Name
        $env:INCLUDE += ";$sdkPath\Include\$sdkVersion\ucrt;$sdkPath\Include\$sdkVersion\um;$sdkPath\Include\$sdkVersion\shared"
        $env:LIB += ";$sdkPath\Lib\$sdkVersion\ucrt\x64;$sdkPath\Lib\$sdkVersion\um\x64"
    }
    
    $compileCmd = "& `"$clPath`" /std:c++17 /EHsc /W3 /O2 /Fe:`"$outputExe`" `"$sourceFile`" ws2_32.lib"
    Write-Host "Comando: $compileCmd" -ForegroundColor Gray
    Invoke-Expression $compileCmd
    
} elseif ($gccPath) {
    Write-Host "Usando GCC/MinGW" -ForegroundColor Cyan
    
    $compileCmd = "& `"$gccPath`" -std=c++17 -O2 -static-libgcc -static-libstdc++ -o `"$outputExe`" `"$sourceFile`" -lrabbitmq"
    Write-Host "Comando: $compileCmd" -ForegroundColor Gray
    Invoke-Expression $compileCmd
    
    # Copiar DLLs necessárias
    if (Test-Path $outputExe) {
        Write-Host "`nCopiando DLLs necessárias..." -ForegroundColor Yellow
        $mingwBinDir = Split-Path $gccPath
        $dlls = @(
            "librabbitmq-4.dll",
            "libcrypto-3-x64.dll",
            "libssl-3-x64.dll",
            "libstdc++-6.dll",
            "libgcc_s_seh-1.dll",
            "libwinpthread-1.dll"
        )
        foreach ($dll in $dlls) {
            $dllPath = Join-Path $mingwBinDir $dll
            if (Test-Path $dllPath) {
                Copy-Item $dllPath $outputDir -Force
                Write-Host "  ✓ $dll copiado" -ForegroundColor Green
            } else {
                Write-Host "  ! $dll não encontrado (pode não ser necessário)" -ForegroundColor Yellow
            }
        }
    }
    
} else {
    Write-Host "`nERRO: Nenhum compilador C++ encontrado!" -ForegroundColor Red
    Write-Host "Por favor, instale uma das seguintes opções:" -ForegroundColor Yellow
    Write-Host "  1. Visual Studio 2022 com C++ Desktop Development" -ForegroundColor White
    Write-Host "  2. MinGW-w64 (https://www.mingw-w64.org/)" -ForegroundColor White
    Write-Host "  3. MSYS2 com mingw-w64-x86_64-gcc" -ForegroundColor White
    exit 1
}

# Verifica se a compilação foi bem-sucedida
if (Test-Path $outputExe) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "BUILD CONCLUÍDO COM SUCESSO!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Executável criado em: $outputExe" -ForegroundColor Cyan
    Write-Host "`nPara usar:" -ForegroundColor Yellow
    Write-Host "  .\bin\rabbitmq_cleaner.exe amqp://guest:guest@localhost:5672/ fila_nome `"regex_pattern`"" -ForegroundColor White
} else {
    Write-Host "`n========================================" -ForegroundColor Red
    Write-Host "ERRO NA COMPILAÇÃO!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Verifique os erros acima." -ForegroundColor Yellow
    exit 1
}
