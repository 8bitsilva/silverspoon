$ErrorActionPreference = "Stop"
$repo = "8bitsilva/silverspoon"

try {
    $template = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/$repo/main/millennium-silverspoon/install_silverspoon.lua" -UseBasicParsing
    if ($template.Content -match '(?s)local banner = \[=\[(.*?)\]=\]') {
        Write-Host $matches[1]
    }
} catch {
    Write-Host "Silver Installer"
}
Write-Host "Silver Installer"
Write-Host "----------------------------------------"

$assetUrl = "https://github.com/$repo/releases/download/v1.0.2/SilverSpoon-Installer.zip"

$work = Join-Path ([IO.Path]::GetTempPath()) ("SilverSpoon-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $work -Force | Out-Null
$archive = Join-Path $work "SilverSpoon-Installer.zip"
Invoke-WebRequest -Uri $assetUrl -OutFile $archive
Expand-Archive -LiteralPath $archive -DestinationPath $work -Force

$installer = Join-Path $work "install_silverspoon.ps1"
if (-not (Test-Path -LiteralPath $installer)) { throw "The release package is missing install_silverspoon.ps1." }
& powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $installer -CoreBuildDirectory $work
if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
