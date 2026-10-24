<#
 Silver Installer - Millennium + LuaTools
 Downloads the official Millennium installer and LuaTools installer, then runs them.

 Run:
   powershell -ExecutionPolicy Bypass -File .\SilverInstaller.ps1
#>

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MillenniumUrl = 'https://github.com/SteamClientHomebrew/Installer/releases/latest/download/MillenniumInstaller-Windows.exe'
$LuaToolsUrl   = 'https://github.com/madoiscool/LuaTools/releases/download/v1.3.2/LuaTools-win-Setup.exe'

$WorkDir       = Join-Path $env:TEMP 'SilverInstaller'
$MillenniumExe = Join-Path $WorkDir 'MillenniumInstaller-Windows.exe'
$LuaToolsExe   = Join-Path $WorkDir 'LuaTools-win-Setup.exe'

$banner = @'
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣤⣤⣤⠴⠶⠶⠶⠤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⡿⣉⣰⣿⣿⣟⡁⠀⠀⢀⠙⠳⠾⢧⣭⣛⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣺⣿⣿⣶⡿⠟⠛⠛⠛⠿⣦⣤⣌⡻⣅⠀⠀⠈⢙⢿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡿⣻⡿⣿⠋⠀⠀⠀⠀⠀⠀⢻⣷⡜⢷⡈⢷⡜⠓⢘⣦⡙⢿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣞⣿⣵⣿⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠹⣯⠉⣿⣌⢻⣄⡄⠛⣿⣺⡹⢟⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣾⣿⣿⣿⣟⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣷⡿⣟⣟⣿⣿⡙⡸⣿⡋⣟⡟⣿⡄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⢠⣿⣿⣼⣿⣿⠿⣼⣿⣶⡄⠀⠀⠀⠀⣠⣤⣤⠿⣿⣿⣯⣽⣷⡿⣬⣻⣷⡞⣿⡸⡹⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⡿⡀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣤⣤⣬⠉⠁⠀⠀⠀⠰⠿⠛⠛⠒⠹⣿⣟⣷⣹⣷⡝⢿⣿⣿⣿⣿⣷⣧⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠓⣦⠋⠀⠀⠀⣿⢿⣿⣿⢿⣿⠻⢏⡙⢷⣄⠀⠀⠀⠀⠀⣾⡷⠶⢮⣝⣿⣿⣿⣿⣿⣦⠙⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀
⠀⠀⠀⢀⡀⠀⠀⠉⠀⠀⠀⣰⣯⣿⣿⣿⣿⠛⡶⣦⡁⣀⡿⡀⠀⠀⠀⡿⢙⣓⡆⠈⢻⣿⣿⣿⣿⣿⣿⣷⣝⢻⣿⣿⣿⣷⡀⠀⠀⠀⢠⡆⠀⠀⠀⠀⠀
⠀⠀⢠⣼⢧⠀⠀⠀⠀⠀⢠⣿⣿⢿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠈⠺⠧⠤⢴⠻⠀⠀⣿⣿⣿⣿⣿⣿⣷⣽⣿⣿⣝⢷⡄⠀⢀⠜⠹⢄⡀⠀⠀⠀⠀
⠀⠀⠀⠸⠃⠀⠀⠀⠀⢠⣿⣿⢇⣿⣿⣿⣿⡇⠀⠀⠀⢠⡚⢢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢛⣩⠿⣿⣿⣾⣿⣿⣿⣿⣿⡎⣷⠀⠈⠹⣸⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢠⢿⣿⡟⣸⣿⣿⢻⣿⣿⡄⠀⠀⣠⠬⠥⣉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢋⣴⣿⣿⣿⣿⣿⣿⣿⣿⣧⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢸⡼⣿⠁⣿⣿⣿⣬⣿⣿⣿⣄⠀⢳⣾⣒⠪⠷⣤⠀⠀⠀⠀⠀⠀⢀⣴⣶⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⢹⠀⠀⠀⠀⠀⠀⣤⠀⠀
⠀⠀⠀⠀⠀⠀⠙⠀⢸⣹⣿⡐⣿⣿⢘⣷⠘⣿⢿⣿⣆⠀⠛⠮⠴⠊⠀⠀⠀⠀⠀⣀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⡤⢻⡿⣆⠀⠀⠀⠀⠶⡟⡶⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⡟⣿⣷⣿⣿⡄⣿⡀⢸⣞⣿⣿⣷⣄⠀⠀⠀⢀⡠⠄⠒⠉⣀⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⡝⣦⣿⣷⢸⣷⢻⣧⡀⠀⠀⠀⠉⠁⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⠹⣿⣿⣿⣷⢸⡇⢸⠿⣿⢹⣿⣿⣿⣿⣿⣧⣀⣀⣐⣋⣁⣿⣿⣿⡏⢷⠀⢻⡀⢲⡾⣷⢻⡜⣿⡄⢿⡄⠹⣷⣄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣿⣿⣿⣿⣿⣳⣿⣰⣿⡜⠀⠈⡄⠀⠀⠘⠿⠃⠀⠀⢇⢻⣿⠀⣿⢸⣿⣟⢾⡇⢸⣿⠹⣿⣿⣿⣌⢻⣮⣻⣿⡞⡆⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⣼⢆⠀⠀⠀⠀⠀⠀⢈⡾⣿⢠⣿⣾⣿⠏⣸⣇⢸⣿⡆⢹⣿⣿⣿⣿⣗⠸⣿⣇⢸⠀⠀⠀
⠀⠀⠀⠀⠀⠀⡀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⡿⣻⠁⠀⠀⠀⠀⢿⣄⠉⠒⠢⠤⠒⠂⠉⢃⢹⣿⣿⣿⡟⢀⣿⠁⣾⣾⠻⣄⢹⣿⣿⣿⣿⣣⣽⡟⢸⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠘⠚⠀⢀⣮⣿⢫⣿⣿⣿⣿⣿⢰⢿⢰⠀⠀⠀⠀⠀⠙⠃⠀⠀⠀⠀⠀⠀⠘⣿⣿⡿⢋⣴⠿⠁⣸⣿⢻⠀⠘⣆⢿⣿⣿⣿⣥⣿⢇⡞⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣸⠘⣼⠀⠀⠀⠀⠲⣶⡆⠀⠀⠀⠀⠀⠀⣼⡿⣫⣶⠟⠁⣠⣿⣿⣿⠏⠀⠀⢽⣾⣿⣿⣿⣿⣩⠞⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣾⣿⣼⢿⣿⣿⢻⠸⣿⣿⣿⣆⠹⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣫⡾⢋⣂⣴⣿⣿⣿⡿⠊⠀⠀⠀⢸⣿⣿⣿⣿⣷⠋⠀⠀⠀⠀⠀⠀
'@

function Show-Failure {
    param(
        [string]$Step,
        [string]$Message,
        [string]$Hint
    )
    Write-Host ''
    Write-Host "[FAILED] $Step" -ForegroundColor Red
    Write-Host "  Error : $Message" -ForegroundColor Red
    if ($Hint) { Write-Host "  Fix   : $Hint" -ForegroundColor Yellow }
}

function Install-Millennium {
    Write-Host '[1/4] Preparing...' -ForegroundColor Cyan
    try {
        New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null
        if (Test-Path $MillenniumExe) { Remove-Item $MillenniumExe -Force }
        if (Test-Path $LuaToolsExe) { Remove-Item $LuaToolsExe -Force }
    } catch {
        Show-Failure 'Preparing temp folder' $_.Exception.Message `
            "Make sure you can write to $WorkDir, or close anything using that folder."
        return $false
    }

    Write-Host '[2/4] Downloading Millennium installer...' -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $MillenniumUrl -OutFile $MillenniumExe -UseBasicParsing
    } catch {
        $status = ''
        if ($_.Exception.Response) { $status = " (HTTP $([int]$_.Exception.Response.StatusCode))" }
        Show-Failure 'Millennium download' ($_.Exception.Message + $status) `
            'Check your internet connection and GitHub access, then run again.'
        return $false
    }

    if (-not (Test-Path $MillenniumExe) -or (Get-Item $MillenniumExe).Length -eq 0) {
        Show-Failure 'Millennium download' 'The installer file is missing or empty.' `
            'Check your antivirus quarantine/protection history.'
        return $false
    }

    Write-Host '[3/4] Running Millennium installer...' -ForegroundColor Cyan
    try {
        $proc = Start-Process -FilePath $MillenniumExe -Wait -PassThru
    } catch {
        Show-Failure 'Running Millennium installer' $_.Exception.Message `
            'Try running PowerShell as administrator if permission is required.'
        return $false
    }

    if ($proc.ExitCode -ne 0) {
        Show-Failure 'Running Millennium installer' "The installer exited with code $($proc.ExitCode)." `
            'Close Steam completely (including the system tray) and run again.'
        return $false
    }

    return $true
}

function Install-LuaTools {
    Write-Host '[4/4] Downloading LuaTools installer...' -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $LuaToolsUrl -OutFile $LuaToolsExe -UseBasicParsing

        if (-not (Test-Path $LuaToolsExe) -or (Get-Item $LuaToolsExe).Length -eq 0) {
            throw 'Downloaded installer is missing or empty.'
        }

        Write-Host 'Running LuaTools installer (follow its installer window)...' -ForegroundColor Cyan
        $proc = Start-Process -FilePath $LuaToolsExe -Wait -PassThru

        if ($proc.ExitCode -ne 0) {
            throw "Installer exited with code $($proc.ExitCode)."
        }

        Write-Host '[LuaTools] Installed successfully.' -ForegroundColor Green
        return $true
    } catch {
        Show-Failure 'LuaTools installation' $_.Exception.Message `
            'Check your internet connection, antivirus history, and any installer prompts.'
        return $false
    }
}

Clear-Host
Write-Host $banner -ForegroundColor DarkCyan
Write-Host 'Silver Installer' -ForegroundColor Cyan
Write-Host 'Millennium + LuaTools' -ForegroundColor Gray
Write-Host ('-' * 40) -ForegroundColor Cyan
Write-Host ''

$millenniumOk = Install-Millennium

if ($millenniumOk) {
    Write-Host ''
    Write-Host 'Millennium installed successfully.' -ForegroundColor Green

    if (Install-LuaTools) {
        Write-Host ''
        Write-Host 'All installations completed successfully.' -ForegroundColor Green
    } else {
        Write-Host ''
        Write-Host 'Millennium installed, but LuaTools installation failed.' -ForegroundColor Yellow
    }
} else {
    Write-Host ''
    Write-Host 'Millennium installation failed. LuaTools was not installed.' -ForegroundColor Red
}

try { Remove-Item $WorkDir -Recurse -Force -ErrorAction SilentlyContinue } catch {}
Write-Host ''
Read-Host 'Press Enter to close'
