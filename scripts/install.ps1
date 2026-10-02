$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$Version = "0.2.0"
$DataDir = if ($env:APPDATA) { $env:APPDATA } else { throw "APPDATA is not set" }
$PackageDir = Join-Path $DataDir "typst/packages/local/tuat-typst"
$Target = Join-Path $PackageDir $Version
$Temp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
$Archive = Join-Path $Temp "package.zip"
$Staging = Join-Path $PackageDir ".${Version}.staging.$([System.Guid]::NewGuid().ToString())"
$Backup = Join-Path $PackageDir ".${Version}.backup.$([System.Guid]::NewGuid().ToString())"

try {
    New-Item -ItemType Directory -Path $Temp, $PackageDir -Force | Out-Null
    $Uri = "https://github.com/OJII3/tuat-typst/archive/refs/tags/v$Version.zip"
    Invoke-WebRequest -Uri $Uri -OutFile $Archive -UseBasicParsing
    Expand-Archive -Path $Archive -DestinationPath $Temp
    $Extracted = Get-ChildItem -Path $Temp -Directory | Select-Object -First 1
    if (-not $Extracted -or -not (Test-Path (Join-Path $Extracted.FullName "typst.toml"))) {
        throw "The downloaded archive does not contain typst.toml"
    }
    New-Item -ItemType Directory -Path $Staging -Force | Out-Null
    Copy-Item -Path (Join-Path $Extracted.FullName "*") -Destination $Staging -Recurse -Force

    if (Test-Path $Target) { Move-Item $Target $Backup }
    try {
        Move-Item $Staging $Target
    } catch {
        if (Test-Path $Backup) { Move-Item $Backup $Target }
        throw
    }
    if (Test-Path $Backup) { Remove-Item $Backup -Recurse -Force }
    Write-Host "Installed @local/tuat-typst:$Version"
} finally {
    if (Test-Path $Staging) { Remove-Item $Staging -Recurse -Force }
    if (Test-Path $Temp) { Remove-Item $Temp -Recurse -Force }
}
