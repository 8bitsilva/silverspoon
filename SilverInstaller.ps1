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

function Write-Section([string]$Title) {
    Write-Host ''
    Write-Host "=== $Title ===" -ForegroundColor Cyan
}

function Test-Internet {
    try {
        $null = Invoke-WebRequest -Uri 'https://github.com' -Method Head -UseBasicParsing -TimeoutSec 10
        return $true
    } catch {
        return $false
    }
}

function Get-Choice([string]$Prompt) {
    while ($true) {
        $answer = Read-Host $Prompt
        switch ($answer.Trim().ToLowerInvariant()) {
            '1' { return 'Millennium' }
            '2' { return 'LuaTools' }
            '3' { return 'Both' }
            'q' { return 'Quit' }
            default { Write-Host 'Choose 1, 2, 3, or Q.' -ForegroundColor Yellow }
        }
    }
}

function Install-SelectedApp {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Url,
        [Parameter(Mandatory)][string]$OutFile
    )

    Write-Section "$Name - pre-install checks"
    Write-Host "[CHECK] Temporary folder: $WorkDir"
    try {
        New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null
        Write-Host '[OK] Temporary folder is ready.' -ForegroundColor Green
    } catch {
        Write-Host "[FAILED] Cannot prepare temporary folder: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }

    Write-Host '[CHECK] Internet connection to GitHub...'
    if (-not (Test-Internet)) {
        Write-Host '[FAILED] GitHub could not be reached. Check your connection and try again.' -ForegroundColor Red
        return $false
    }
    Write-Host '[OK] GitHub is reachable.' -ForegroundColor Green

    if (Test-Path $OutFile) {
        Remove-Item $OutFile -Force
    }

    Write-Host "[DOWNLOAD] Source: $Url" -ForegroundColor Yellow
    Write-Host "[DOWNLOAD] Destination: $OutFile" -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
        if (-not (Test-Path $OutFile) -or (Get-Item $OutFile).Length -eq 0) {
            throw 'Downloaded file is missing or empty.'
        }
        $sizeMB = [math]::Round((Get-Item $OutFile).Length / 1MB, 2)
        Write-Host "[OK] Download complete ($sizeMB MB)." -ForegroundColor Green
    } catch {
        Write-Host "[FAILED] Download failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }

    # Basic file metadata check. This is not a guarantee that a file is safe.
    try {
        $signature = Get-AuthenticodeSignature -FilePath $OutFile
        Write-Host "[CHECK] Authenticode signature status: $($signature.Status)"
        if ($signature.Status -eq 'Valid') {
            Write-Host "[OK] Signature valid. Signer: $($signature.SignerCertificate.Subject)" -ForegroundColor Green
        } elseif ($signature.Status -eq 'NotSigned') {
            Write-Host '[INFO] File is not Authenticode-signed; review the source before continuing.' -ForegroundColor Yellow
        } else {
            Write-Host "[WARNING] Signature status is $($signature.Status)." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[INFO] Could not inspect digital signature: $($_.Exception.Message)" -ForegroundColor Yellow
    }

    Write-Host ''
    Write-Host "Ready to launch: $Name" -ForegroundColor Cyan
    Write-Host 'The installer may request administrator permission or make system changes.'
    $confirm = Read-Host "Launch $Name installer now? Type Y to continue (anything else cancels)"
    if ($confirm.Trim().ToUpperInvariant() -ne 'Y') {
        Write-Host "[CANCELLED] $Name installer was not launched." -ForegroundColor Yellow
        Remove-Item $OutFile -Force -ErrorAction SilentlyContinue
        return $false
    }

    try {
        Write-Host "[RUNNING] Starting $Name installer. Follow its window; this script will wait for it to close..." -ForegroundColor Cyan
        $proc = Start-Process -FilePath $OutFile -Wait -PassThru
        Write-Host "[INFO] $Name installer exit code: $($proc.ExitCode)"
        if ($proc.ExitCode -eq 0) {
            Write-Host "[SUCCESS] $Name installer finished successfully." -ForegroundColor Green
            Remove-Item $OutFile -Force -ErrorAction SilentlyContinue
            return $true
        } else {
            Write-Host "[WARNING] $Name installer returned exit code $($proc.ExitCode)." -ForegroundColor Yellow
            Write-Host '[INFO] Some installers use non-zero exit codes for cancellation or reboot-required states; check the installer window.' -ForegroundColor Yellow
            return $false
        }
    } catch {
        Write-Host "[FAILED] Could not start $Name installer: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

Clear-Host
Write-Host 'Silver Installer' -ForegroundColor Cyan
Write-Host 'Millennium + LuaTools' -ForegroundColor Gray
Write-Host ('-' * 44) -ForegroundColor Cyan
Write-Host 'This script will check connectivity, download only the selected installer(s),' -ForegroundColor White
Write-Host 'show download/signature status, and ask before launching each installer.' -ForegroundColor White
Write-Host 'It will not silently install either application.' -ForegroundColor Green

Write-Section 'Initial checks'
Write-Host "[INFO] PowerShell version: $($PSVersionTable.PSVersion)"
Write-Host "[INFO] Windows: $([System.Environment]::OSVersion.VersionString)"
Write-Host "[INFO] Temporary directory: $env:TEMP"
Write-Host '[CHECK] GitHub connectivity...'
if (Test-Internet) {
    Write-Host '[OK] GitHub is reachable.' -ForegroundColor Green
} else {
    Write-Host '[WARNING] GitHub is not reachable right now. Downloads may fail.' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'What would you like to install?' -ForegroundColor Cyan
Write-Host '  1. Millennium only'
Write-Host '  2. LuaTools only'
Write-Host '  3. Both'
Write-Host '  Q. Quit without installing'
$selection = Get-Choice 'Select an option'

if ($selection -eq 'Quit') {
    Write-Host 'Exiting without downloading or installing anything.' -ForegroundColor Yellow
    return
}

$apps = @()
if ($selection -eq 'Millennium' -or $selection -eq 'Both') {
    $apps += [pscustomobject]@{ Name = 'Millennium'; Url = $MillenniumUrl; Path = $MillenniumExe }
}
if ($selection -eq 'LuaTools' -or $selection -eq 'Both') {
    $apps += [pscustomobject]@{ Name = 'LuaTools'; Url = $LuaToolsUrl; Path = $LuaToolsExe }
}

Write-Host ''
Write-Host 'Selected: ' -NoNewline
Write-Host (($apps | ForEach-Object { $_.Name }) -join ', ') -ForegroundColor Yellow
$overallConfirm = Read-Host 'Continue to the pre-install checks and downloads? Type Y to continue'
if ($overallConfirm.Trim().ToUpperInvariant() -ne 'Y') {
    Write-Host 'Cancelled. Nothing was downloaded or installed.' -ForegroundColor Yellow
    return
}

$results = @()
foreach ($app in $apps) {
    $ok = Install-SelectedApp -Name $app.Name -Url $app.Url -OutFile $app.Path
    $results += [pscustomobject]@{ Name = $app.Name; Success = $ok }
    Write-Host ''
}

Write-Section 'Summary'
foreach ($result in $results) {
    if ($result.Success) {
        Write-Host "[SUCCESS] $($result.Name)" -ForegroundColor Green
    } else {
        Write-Host "[NOT COMPLETED] $($result.Name)" -ForegroundColor Yellow
    }
}
try { Remove-Item $WorkDir -Recurse -Force -ErrorAction SilentlyContinue } catch {}
Write-Host ''
Read-Host 'Press Enter to close'
