<#
 Silver Installer - Millennium + LuaTools
 Interactive installer with banner, checks, selection, and confirmation prompts.

 Run:
   powershell -ExecutionPolicy Bypass -File .\SilverInstaller.ps1
#>

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
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
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡿⣻⡿⣿⠋⠀⠀⠀⠀⠀⠀⢻⣷⡜⢷⡈⢷⡈⢷⡜⠓⢘⣦⡙⢿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
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

function Test-GitHub {
    try {
        $null = Invoke-WebRequest -Uri 'https://github.com' -Method Head -UseBasicParsing -TimeoutSec 10
        return $true
    } catch {
        return $false
    }
}

function Get-InstallChoice {
    while ($true) {
        Write-Host ''
        Write-Host 'What would you like to install?' -ForegroundColor Cyan
        Write-Host '  1. Millennium only'
        Write-Host '  2. LuaTools only'
        Write-Host '  3. Both'
        Write-Host '  Q. Quit'
        $choice = (Read-Host 'Select an option').Trim().ToLowerInvariant()
        switch ($choice) {
            '1' { return 'Millennium' }
            '2' { return 'LuaTools' }
            '3' { return 'Both' }
            'q' { return 'Quit' }
            default { Write-Host 'Invalid choice. Enter 1, 2, 3, or Q.' -ForegroundColor Yellow }
        }
    }
}

function Install-SelectedApp {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Url,
        [Parameter(Mandatory)][string]$OutFile
    )

    Write-Section "$Name - checks and download"
    try {
        New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null
        Write-Host "[OK] Temporary directory ready: $WorkDir" -ForegroundColor Green
    } catch {
        Write-Host "[FAILED] Cannot prepare temporary directory: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }

    Write-Host '[CHECK] Testing GitHub connectivity...'
    if (-not (Test-GitHub)) {
        Write-Host '[FAILED] Cannot reach GitHub. Check your connection and retry.' -ForegroundColor Red
        return $false
    }
    Write-Host '[OK] GitHub is reachable.' -ForegroundColor Green

    Remove-Item $OutFile -Force -ErrorAction SilentlyContinue
    Write-Host "[DOWNLOAD] From: $Url" -ForegroundColor Yellow
    Write-Host "[DOWNLOAD] To:   $OutFile" -ForegroundColor Yellow

    try {
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
        if (-not (Test-Path $OutFile) -or (Get-Item $OutFile).Length -eq 0) {
            throw 'Downloaded installer is missing or empty.'
        }
        $sizeMB = [math]::Round((Get-Item $OutFile).Length / 1MB, 2)
        Write-Host "[OK] Download completed. File size: $sizeMB MB" -ForegroundColor Green
    } catch {
        Write-Host "[FAILED] Download error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }

    try {
        $sig = Get-AuthenticodeSignature -FilePath $OutFile
        Write-Host "[CHECK] Digital signature: $($sig.Status)"
        if ($sig.Status -eq 'Valid') {
            Write-Host "[OK] Signed by: $($sig.SignerCertificate.Subject)" -ForegroundColor Green
        } elseif ($sig.Status -eq 'NotSigned') {
            Write-Host '[WARNING] Installer has no Authenticode signature. Verify the official source before proceeding.' -ForegroundColor Yellow
        } else {
            Write-Host "[WARNING] Signature status: $($sig.Status). Review before proceeding." -ForegroundColor Yellow
        }
    } catch {
        Write-Host '[INFO] Could not read signature metadata.' -ForegroundColor Yellow
    }

    Write-Host ''
    Write-Host "Ready to launch $Name." -ForegroundColor Cyan
    Write-Host 'The installer may request administrator permission and make changes to your system.'
    $confirm = (Read-Host "Type Y to launch $Name, or anything else to cancel").Trim()
    if ($confirm -notmatch '^(?i)y$') {
        Write-Host "[CANCELLED] $Name was not launched." -ForegroundColor Yellow
        Remove-Item $OutFile -Force -ErrorAction SilentlyContinue
        return $false
    }

    try {
        Write-Host "[RUNNING] Launching $Name. Follow the installer window..." -ForegroundColor Cyan
        $proc = Start-Process -FilePath $OutFile -Wait -PassThru
        Write-Host "[INFO] Process exit code: $($proc.ExitCode)"
        if ($proc.ExitCode -eq 0) {
            Write-Host "[SUCCESS] $Name installer finished." -ForegroundColor Green
            Remove-Item $OutFile -Force -ErrorAction SilentlyContinue
            return $true
        }

        Write-Host "[WARNING] $Name returned exit code $($proc.ExitCode). Check its installer window; this may indicate cancellation or a reboot requirement." -ForegroundColor Yellow
        return $false
    } catch {
        Write-Host "[FAILED] Could not start $Name`: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

Clear-Host
Write-Host $banner -ForegroundColor DarkCyan
Write-Host ''
Write-Host 'Silver Installer' -ForegroundColor Cyan
Write-Host 'Millennium + LuaTools' -ForegroundColor Gray
Write-Host ('-' * 44) -ForegroundColor Cyan
Write-Host 'Interactive installer with visible checks and confirmations.' -ForegroundColor White
Write-Host 'Nothing is downloaded until you choose an option and confirm.' -ForegroundColor Green

Write-Section 'Initial checks'
Write-Host "[INFO] PowerShell: $($PSVersionTable.PSVersion)"
Write-Host "[INFO] Operating system: $([System.Environment]::OSVersion.VersionString)"
Write-Host "[INFO] Temporary directory: $env:TEMP"
Write-Host '[CHECK] GitHub connectivity...'
if (Test-GitHub) {
    Write-Host '[OK] GitHub is reachable.' -ForegroundColor Green
} else {
    Write-Host '[WARNING] GitHub could not be reached. Downloads may fail.' -ForegroundColor Yellow
}

$selection = Get-InstallChoice
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
Write-Host "Selected: $(($apps | ForEach-Object { $_.Name }) -join ', ')" -ForegroundColor Yellow
$proceed = (Read-Host 'Continue? Type Y to proceed, or anything else to cancel').Trim()
if ($proceed -notmatch '^(?i)y$') {
    Write-Host 'Cancelled. Nothing was downloaded or installed.' -ForegroundColor Yellow
    return
}

$results = @()
foreach ($app in $apps) {
    $success = Install-SelectedApp -Name $app.Name -Url $app.Url -OutFile $app.Path
    $results += [pscustomobject]@{ Name = $app.Name; Success = $success }
}

Write-Section 'Installation summary'
foreach ($result in $results) {
    if ($result.Success) {
        Write-Host "[SUCCESS] $($result.Name)" -ForegroundColor Green
    } else {
        Write-Host "[NOT COMPLETED] $($result.Name)" -ForegroundColor Yellow
    }
}
Remove-Item $WorkDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ''
Read-Host 'Press Enter to close'
