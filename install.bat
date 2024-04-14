@echo off

@rem Define the path to the directory where the script is located

if defined APPDATA (set DATA_DIR=%APPDATA%) else (echo [Error] %%APPDATA%% is not defined & exit /b 1)
echo [info] DATA_DIR is set to: %DATA_DIR%

set "NAMESPACE=local"
set "NAME=tuat-typst"
set "VERSION=0.1.0"

set "FULL_PATH=%DATA_DIR%/typst/packages/%NAMESPACE%/%NAME%/%VERSION%"
set "TEMP_DIR=%TEMP%/%NAME%"

@rem Check if git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (echo [Error] git is not installed & exit /b 1)
echo [info] git already installed

@rem Create temp directory to clone the repository
if exist %TEMP_DIR% (echo %TEMP_DIR% is already exist and delete this to continue & rmdir "%TEMP_DIR%" /s)
if exist %TEMP_DIR% (echo Canceled & exit /b 1)
mkdir "%FULL_PATH%"

@rem Clone
git clone --depth 1 https://github.com/ojii3/tuat-typst.git "%TEMP_DIR%"
if %ERRORLEVEL% NEQ 0 (echo [Error] filed to clone & exit /b 1)
echo [info] clone succeeded

@rem Copy the files to the destination directory
xcopy "%TEMP_DIR%" "%FULL_PATH%" /s /q /y
if %ERRORLEVEL% NEQ 0 (echo [Error] filed to copy directory from %TEMP_DIR% to %DATA_DIR% & exit /b 1)
echo [info] copy succeeded

@rem Clean up
rmdir /s /q "%TEMP_DIR%"
if %ERRORLEVEL% NEQ 0 (echo [info] filed to clean up, but install finished successfully )

echo ========================================
echo Installation completed successfully!