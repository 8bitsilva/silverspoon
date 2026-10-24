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

$release = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest" -Headers @{ "User-Agent" = "SilverSpoon-Installer" }
$asset = $release.assets | Where-Object { $_.name -eq "SilverSpoon-Installer.zip" } | Select-Object -First 1
if (-not $asset) { throw "The latest SilverSpoon release does not contain SilverSpoon-Installer.zip." }

$work = Join-Path ([IO.Path]::GetTempPath()) ("SilverSpoon-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $work -Force | Out-Null
$archive = Join-Path $work "SilverSpoon-Installer.zip"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archive
Expand-Archive -LiteralPath $archive -DestinationPath $work -Force

$installer = Join-Path $work "install_silverspoon.ps1"
if (-not (Test-Path -LiteralPath $installer)) { throw "The release package is missing install_silverspoon.ps1." }
& powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $installer -CoreBuildDirectory $work
if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
