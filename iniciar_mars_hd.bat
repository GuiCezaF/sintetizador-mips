@echo off
setlocal EnableDelayedExpansion

cd /d "%~dp0"

echo ============================================================
echo   INICIADOR HD - MAQUINA DE MUSICA MIPS (MARS 4.5)
echo ============================================================
echo Diretorio de trabalho: %CD%
echo.

set "GERVILL_DIR=%USERPROFILE%\.gervill"
set "GERVILL_SF2=%GERVILL_DIR%\soundbank-emg.sf2"
set "SF2_FOUND="

for %%F in ("%~dp0*.sf2") do (
    set "SF2_FOUND=%%~fF"
    goto :install_sf2
)

if exist "%GERVILL_SF2%" (
    echo [OK] SoundFont HD ja instalado em: %GERVILL_SF2%
) else (
    echo [INFO] Nenhum arquivo .sf2 encontrado na pasta do projeto.
    echo        O MARS usara o banco de som padrao do Java.
    echo        Consulte SOUNDFONT.md para melhorar o audio.
)
goto :find_java

:install_sf2
echo [INFO] SoundFont encontrado: %SF2_FOUND%
if not exist "%GERVILL_DIR%" mkdir "%GERVILL_DIR%"
copy /Y "%SF2_FOUND%" "%GERVILL_SF2%" >nul
if errorlevel 1 (
    echo [ERRO] Falha ao copiar SoundFont para %GERVILL_SF2%.
) else (
    echo [OK] SoundFont HD ativado em: %GERVILL_SF2%
)

:find_java
echo.
where java >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Java nao encontrado no PATH. Instale o JDK/JRE para executar o MARS.
    pause
    exit /b 1
)

set "MARS_JAR="
for %%J in ("%~dp0mars\Mars*.jar") do (
    set "MARS_JAR=%%~fJ"
    goto :found_mars
)
for %%J in ("%~dp0Mars*.jar") do (
    set "MARS_JAR=%%~fJ"
    goto :found_mars
)
for %%J in ("%USERPROFILE%\Downloads\Mars*.jar") do (
    set "MARS_JAR=%%~fJ"
    goto :found_mars
)
for %%J in ("%USERPROFILE%\Desktop\Mars*.jar") do (
    set "MARS_JAR=%%~fJ"
    goto :found_mars
)

echo [INFO] Mars4_5.jar nao encontrado na pasta do projeto, Downloads ou Desktop.
set /p "MARS_JAR=Digite ou arraste o caminho completo do Mars4_5.jar: "
set "MARS_JAR=%MARS_JAR:"=%"

if not exist "%MARS_JAR%" (
    echo [ERRO] Arquivo nao encontrado: %MARS_JAR%
    pause
    exit /b 1
)

:found_mars
echo [OK] MARS encontrado: %MARS_JAR%
echo [INFO] Abrindo sintetizador.asm no MARS...
echo        (No MARS, pressione F3 para montar e F5 para executar)
echo.

start "" java -jar "%MARS_JAR%" "%~dp0sintetizador.asm"
exit /b 0
