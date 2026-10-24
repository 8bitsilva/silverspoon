$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path $PSScriptRoot).Path
$stagePath = Join-Path $projectRoot "bundle_contents"
$zipPath = Join-Path $projectRoot "SilverSpoon-Store-Companion.zip"

if (Test-Path -LiteralPath $stagePath) {
    $resolvedStage = (Resolve-Path -LiteralPath $stagePath).Path
    if (-not $resolvedStage.StartsWith($projectRoot, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to clean staging path outside the project directory."
    }
    Remove-Item -LiteralPath $resolvedStage -Recurse -Force
}

New-Item -ItemType Directory -Path (Join-Path $stagePath "webview") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $stagePath "resources") -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $projectRoot "README.md"), (Join-Path $projectRoot "millennium.toml"), (Join-Path $projectRoot "package.json"), (Join-Path $projectRoot "package-lock.json"), (Join-Path $projectRoot "bundle.ps1"), (Join-Path $projectRoot "install_silverspoon.lua"), (Join-Path $projectRoot "install_silverspoon.ps1") -Destination $stagePath
Copy-Item -LiteralPath (Join-Path $projectRoot "webview\preload.ts") -Destination (Join-Path $stagePath "webview\preload.ts")
Copy-Item -LiteralPath (Join-Path $projectRoot "resources\silverspoon.png") -Destination (Join-Path $stagePath "resources\silverspoon.png")
Copy-Item -LiteralPath (Join-Path $projectRoot "resources\silverspoon-icon.png") -Destination (Join-Path $stagePath "resources\silverspoon-icon.png")
Copy-Item -LiteralPath (Join-Path $projectRoot "resources\starlight-win32-x64.exe") -Destination (Join-Path $stagePath "resources\starlight-win32-x64.exe")
Copy-Item -LiteralPath (Join-Path $projectRoot "resources\STARLIGHT-LICENSE.txt") -Destination (Join-Path $stagePath "resources\STARLIGHT-LICENSE.txt")
Copy-Item -LiteralPath (Join-Path $projectRoot "dist") -Destination (Join-Path $stagePath "SilverSpoon-Store-Companion.dist")

if (Test-Path -LiteralPath $zipPath) {
    Remove-Item -LiteralPath $zipPath -Force
}
Compress-Archive -Path (Join-Path $stagePath "*") -DestinationPath $zipPath -CompressionLevel Optimal
Get-Item -LiteralPath $zipPath | Select-Object FullName, Length
Remove-Item -LiteralPath $stagePath -Recurse -Force
