$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$Version = "0.2.0"
$DataDir = if ($env:APPDATA) { $env:APPDATA } else { throw "APPDATA is not set" }
$PackageDir = Join-Path $DataDir "typst/packages/local/tuat-typst"
$Target = Join-Path $PackageDir $Version
$Temp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
$Asset = "tuat-typst-v$Version.zip"
$Archive = Join-Path $Temp $Asset
$Checksums = Join-Path $Temp "SHA256SUMS"
$ExtractDir = Join-Path $Temp "extracted"
$Staging = Join-Path $PackageDir ".${Version}.staging.$([System.Guid]::NewGuid().ToString())"
$Backup = Join-Path $PackageDir ".${Version}.backup.$([System.Guid]::NewGuid().ToString())"

try {
    New-Item -ItemType Directory -Path $Temp, $PackageDir -Force | Out-Null
    $ReleaseUrl = "https://github.com/OJII3/tuat-typst/releases/download/v$Version"
    Invoke-WebRequest -Uri "$ReleaseUrl/$Asset" -OutFile $Archive -UseBasicParsing
    Invoke-WebRequest -Uri "$ReleaseUrl/SHA256SUMS" -OutFile $Checksums -UseBasicParsing
    $ChecksumPattern = '^[a-fA-F0-9]{64}\s+\*?' + [regex]::Escape($Asset) + '$'
    $ChecksumLine = Get-Content $Checksums | Where-Object { $_ -match $ChecksumPattern } | Select-Object -First 1
    $ActualChecksum = (Get-FileHash -Path $Archive -Algorithm SHA256).Hash.ToLowerInvariant()
    $ExpectedChecksum = [regex]::Match($ChecksumLine, '^[a-fA-F0-9]{64}').Value.ToLowerInvariant()
    if (-not $ExpectedChecksum -or $ExpectedChecksum -ne $ActualChecksum) {
        throw "The downloaded package checksum does not match"
    }
    New-Item -ItemType Directory -Path $ExtractDir | Out-Null
    Expand-Archive -Path $Archive -DestinationPath $ExtractDir
    if (Test-Path (Join-Path $ExtractDir "typst.toml")) {
        $Extracted = Get-Item $ExtractDir
    } else {
        $Extracted = Get-ChildItem -Path $ExtractDir -Directory | Select-Object -First 1
    }
    if (-not $Extracted -or -not (Test-Path (Join-Path $Extracted.FullName "typst.toml"))) {
        throw "The downloaded archive does not contain typst.toml"
    }
    $Manifest = Get-Content (Join-Path $Extracted.FullName "typst.toml") -Raw
    $VersionPattern = '(?m)^version = "' + [regex]::Escape($Version) + '"$'
    if ($Manifest -notmatch $VersionPattern) {
        throw "The downloaded package version does not match $Version"
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
