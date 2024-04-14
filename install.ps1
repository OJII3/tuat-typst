# Define the path to the directory where the script is located

if (Test-Path $env:APPDATA) {
    $Data_DIR=$env:APPDATA
} else {
    Write-Host "[Error] env:APPDATA is not exist" -ForegroundColor Red
    exit 1
}
Write-Host "[info] DATA_DIR is set to: $DATA_DIR"

$NAME_SPACE="local"
$NAME="tuat-typst"
$VERSION="0.1.0"

$FULL_PATH="$DATA_DIR/typst/packages/$NAMESPACE/$NAME/$VERSION"
$TEMP_DIR="$env:TEMP/$NAME"

# Check if git is installed
if (-Not (gcm git -ea SilentlyContinue)) {
    Write-Host "[Error] git is not installed" -ForegroundColor Red
    exit 1
}
Write-Host "[info] git already installed"

# Create temp directory to clone the repository
if (Test-Path $TEMP_DIR) {
    Write-Host "$TEMP_DIR is already exist and delete this to continue" -ForegroundColor Yellow
    Remove-Item "$TEMP_DIR" -Force -Recurse -Confirm
}
if (Test-Path $TEMP_DIR) {
    Write-Host "Canceled"
    exit 1
}

# Clone
git clone --depth 1 https://github.com/ojii3/tuat-typst.git "$TEMP_DIR"
if ($LastExitCode -ge 1) {
    Write-Host "[Error] filed to clone" -ForegroundColor Red
    exit 1
}
Write-Host "[info] clone succeeded"

# Copy the files to the destination directory
robocopy "$TEMP_DIR" "$FULL_PATH" /E /PURGE | Out-Null
if ($LastExitCode -ge 8) {
    Write-Host "[Error] filed to copy directory from $TEMP_DIR to $DATA_DIR" -ForegroundColor Red
    exit 1
}
Write-Host "[info] copy succeeded"

# Clean up
Remove-Item "$TEMP_DIR" -Force -Recurse
if (Test-Path $TEMP_DIR) {
    Write-Host "[info] failed to clean up, but install finished successfully" -ForegroundColor Yellow
}

Write-Host "========================================"
Write-Host "Installation completed successfully!" -ForegroundColor Green