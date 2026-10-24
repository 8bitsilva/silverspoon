$ErrorActionPreference = "Stop"

@"
   _____ _ _                 _____                         
  / ____(_) |               / ____|                        
 | (___  _| |__   ___ _ __ | (___  _ __   ___   ___  _ __ 
  \___ \| | '_ \ / _ \ '__| \___ \| '_ \ / _ \ / _ \| '_ \
  ____) | | | | |  __/ |    ____) | |_) | (_) | (_) | | | |
 |_____/|_|_| |_|\___|_|   |_____/| .__/ \___/ \___/|_| |_|
                                  | |                      
                                  |_|                      
"@ | Write-Host
Write-Host "Silver Installer"
Write-Host "----------------------------------------"

$repo = "8bitsilva/silverspoon"
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
