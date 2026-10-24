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

$releases = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases?per_page=30" -Headers @{ "User-Agent" = "SilverSpoon-Installer" }
$release = $releases |
    Where-Object { -not $_.draft -and -not $_.prerelease -and $_.tag_name -match '^v\d+\.\d+\.\d+$' } |
    Sort-Object { [version]$_.tag_name.TrimStart('v') } -Descending |
    Select-Object -First 1
if (-not $release) { throw "No published SilverSpoon release was found." }
$asset = $null
foreach ($candidate in $releases) {
    foreach ($candidateAsset in @($candidate.assets)) {
        if ($candidateAsset.name -eq "SilverSpoon-Installer.zip") {
            $asset = $candidateAsset
            break
        }
    }
    if ($asset) { break }
}
if (-not $asset) {
    $asset = [pscustomobject]@{
        browser_download_url = "https://github.com/$repo/releases/download/v1.0.2/SilverSpoon-Installer.zip"
    }
}

$work = Join-Path ([IO.Path]::GetTempPath()) ("SilverSpoon-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $work -Force | Out-Null
$archive = Join-Path $work "SilverSpoon-Installer.zip"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archive
Expand-Archive -LiteralPath $archive -DestinationPath $work -Force

$installer = Join-Path $work "install_silverspoon.ps1"
if (-not (Test-Path -LiteralPath $installer)) { throw "The release package is missing install_silverspoon.ps1." }
& powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $installer -CoreBuildDirectory $work
if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
