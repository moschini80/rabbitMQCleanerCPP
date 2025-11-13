@echo off
REM Script de build para RabbitMQ Cleaner

echo Compilando RabbitMQ Cleaner...

REM Configura ambiente do Visual Studio
call "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat"

REM Cria diretório de saída
if not exist "bin" mkdir bin

REM Compila o projeto
cl.exe /std:c++17 /EHsc /W3 /O2 /Fe:bin\rabbitmq_cleaner.exe src\main.cpp ws2_32.lib

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Build concluído com sucesso!
    echo Executável: bin\rabbitmq_cleaner.exe
    echo ========================================
) else (
    echo.
    echo ========================================
    echo Erro durante a compilação!
    echo ========================================
)

pause
