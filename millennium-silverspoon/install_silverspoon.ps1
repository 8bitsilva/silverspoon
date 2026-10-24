param(
    [string]$CoreBuildDirectory = ""
)

$ErrorActionPreference = "Stop"

function Find-SteamRoot {
    $registryLocations = @(
        @{ Path = "HKCU:\Software\Valve\Steam"; Name = "SteamPath" },
        @{ Path = "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam"; Name = "InstallPath" },
        @{ Path = "HKLM:\SOFTWARE\Valve\Steam"; Name = "InstallPath" }
    )

    foreach ($location in $registryLocations) {
        try {
            $value = (Get-ItemProperty -LiteralPath $location.Path -Name $location.Name -ErrorAction Stop).($location.Name)
            if ($value) {
                $candidate = [Environment]::ExpandEnvironmentVariables($value)
                if (Test-Path -LiteralPath (Join-Path $candidate "steam.exe")) { return $candidate }
            }
        } catch { }
    }

    $manualPath = Read-Host "Steam was not found in the registry. Enter the folder containing steam.exe"
    if (-not (Test-Path -LiteralPath (Join-Path $manualPath "steam.exe"))) {
        throw "Steam.exe was not found at the supplied path."
    }
    return (Resolve-Path -LiteralPath $manualPath).Path
}

function Test-MillenniumInstalled([string]$SteamRoot) {
    return (Test-Path -LiteralPath (Join-Path $SteamRoot "millennium")) -and
        ((Test-Path -LiteralPath (Join-Path $SteamRoot "wsock32.dll")) -or
         (Test-Path -LiteralPath (Join-Path $SteamRoot "version.dll")))
}

$steamRoot = Find-SteamRoot
$millenniumPresent = Test-MillenniumInstalled $steamRoot

if ([string]::IsNullOrWhiteSpace($CoreBuildDirectory)) {
    $repoBuild = Join-Path $PSScriptRoot "..\build\Release"
    if (Test-Path -LiteralPath $repoBuild) {
        $CoreBuildDirectory = (Resolve-Path -LiteralPath $repoBuild).Path
    }
}

Write-Host "Steam: $steamRoot"
if (-not $millenniumPresent) {
    $answer = Read-Host "Millennium is not installed. Download and launch its official signed installer now? [y/N]"
    if ($answer -notmatch "^(y|yes)$") { throw "Install cancelled by the user." }

    $installerUrl = "https://github.com/SteamClientHomebrew/Installer/releases/latest/download/MillenniumInstaller-Windows.exe"
    $installerPath = Join-Path $env:TEMP "MillenniumInstaller-Windows.exe"
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
    $signature = Get-AuthenticodeSignature -FilePath $installerPath
    if ($signature.Status -ne "Valid") {
        Remove-Item -LiteralPath $installerPath -Force -ErrorAction SilentlyContinue
        throw "The Millennium installer signature is not valid. The installer was not launched."
    }

    $installerProcess = Start-Process -FilePath $installerPath -Wait -PassThru
    Remove-Item -LiteralPath $installerPath -Force -ErrorAction SilentlyContinue
    if ($installerProcess.ExitCode -ne 0) {
        throw "Millennium installer exited with code $($installerProcess.ExitCode)."
    }
    if (-not (Test-MillenniumInstalled $steamRoot)) {
        throw "Millennium installation was not detected after the installer completed."
    }
}

$installAnswer = Read-Host "Install or update the SilverSpoon Store Companion in Millennium now? [y/N]"
if ($installAnswer -notmatch "^(y|yes)$") { throw "Companion installation cancelled by the user." }

if (-not [string]::IsNullOrWhiteSpace($CoreBuildDirectory)) {
    $nativeFiles = @("SilverSpoon.dll", "dwmapi.dll", "xinput1_4.dll")
    $missingNative = @($nativeFiles | Where-Object { -not (Test-Path -LiteralPath (Join-Path $CoreBuildDirectory $_)) })
    if ($missingNative.Count -eq 0) {
        $nativeAnswer = Read-Host "Install SilverSpoon native DLLs from '$CoreBuildDirectory' into Steam? [y/N]"
        if ($nativeAnswer -match "^(y|yes)$") {
            foreach ($nativeFile in $nativeFiles) {
                Copy-Item -LiteralPath (Join-Path $CoreBuildDirectory $nativeFile) -Destination (Join-Path $steamRoot $nativeFile) -Force
            }
            Write-Host "Installed SilverSpoon.dll, dwmapi.dll, and xinput1_4.dll."
        }
    } else {
        Write-Warning "Native build is incomplete. Missing: $($missingNative -join ', '). Companion installation will continue."
    }
} else {
    Write-Host "No native SilverSpoon build directory was supplied. Installing the companion only."
}

$compiler = Join-Path $PSScriptRoot "resources\starlight-win32-x64.exe"
if (-not (Test-Path -LiteralPath $compiler)) {
    throw "Bundled Starlight compiler is missing: $compiler"
}

$projectConfig = Join-Path $PSScriptRoot "millennium.toml"
$installConfig = Join-Path $PSScriptRoot "millennium.install.toml"
$configText = [IO.File]::ReadAllText($projectConfig)
if (-not $configText.Contains('output_path = "./dist"')) {
    throw "The expected build output setting was not found. Review millennium.toml before continuing."
}
$configText = $configText.Replace('output_path = "./dist"', 'output_path = "auto"')
[IO.File]::WriteAllText($installConfig, $configText, [Text.UTF8Encoding]::new($false))

try {
    Push-Location $PSScriptRoot
    & $compiler pack --release --config $installConfig
    if ($LASTEXITCODE -ne 0) { throw "Starlight failed with exit code $LASTEXITCODE." }
} finally {
    Pop-Location -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $installConfig -Force -ErrorAction SilentlyContinue
}

$restartAnswer = Read-Host "The companion is installed. Close and restart Steam now? [y/N]"
if ($restartAnswer -match "^(y|yes)$") {
    $steamProcess = Get-Process -Name steam -ErrorAction SilentlyContinue
    if ($steamProcess) {
        Start-Process -FilePath "steam://exit"
        $deadline = (Get-Date).AddSeconds(30)
        do {
            Start-Sleep -Seconds 1
            $steamProcess = Get-Process -Name steam -ErrorAction SilentlyContinue
        } while ($steamProcess -and (Get-Date) -lt $deadline)
    }

    if (Get-Process -Name steam -ErrorAction SilentlyContinue) {
        Write-Warning "Steam did not exit within 30 seconds. It was left running; restart it manually."
    } else {
        Start-Process -FilePath (Join-Path $steamRoot "steam.exe")
        Write-Host "Steam restarted. Open any game store page to see SilverSpoon."
    }
} else {
    Write-Host "Installation finished. Restart Steam later to load the companion."
}
