Clear-Host

Write-Host @"
  ██████╗ ███████╗██████╗     ██╗      ██████╗ ████████╗██╗   ██╗███████╗         
  ██╔══██╗██╔════╝██╔══██╗    ██║     ██╔═══██╗╚══██╔══╝██║   ██║██╔════╝         
  ██████╔╝█████╗  ██║  ██║    ██║     ██║   ██║   ██║   ██║   ██║███████╗         
  ██╔══██╗██╔══╝  ██║  ██║    ██║     ██║   ██║   ██║   ██║   ██║╚════██║         
  ██║  ██║███████╗██████╔╝    ███████╗╚██████╔╝   ██║   ╚██████╔╝███████║         
  ╚═╝  ╚═╝╚══════╝╚═════╝     ╚══════╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝         
                                                                                  
  ███████╗██╗ ██████╗ ███╗   ██╗ █████╗ ████████╗██╗   ██╗██████╗ ███████╗███████╗
  ██╔════╝██║██╔════╝ ████╗  ██║██╔══██╗╚══██╔══╝██║   ██║██╔══██╗██╔════╝██╔════╝
  ███████╗██║██║  ███╗██╔██╗ ██║███████║   ██║   ██║   ██║██████╔╝█████╗  ███████╗
  ╚════██║██║██║   ██║██║╚██╗██║██╔══██║   ██║   ██║   ██║██╔══██╗██╔══╝  ╚════██║
  ███████║██║╚██████╔╝██║ ╚████║██║  ██║   ██║   ╚██████╔╝██║  ██║███████╗███████║
  ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
                                                                                  
"@ -ForegroundColor Red
Write-Host ""
Write-Host "  Made by Bacanoicua kjj - " -ForegroundColor Blue -NoNewLine
Write-Host -ForegroundColor Red "discord.gg/redlotus"

Write-Host ""
function Test-Admin {;$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent());$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);}
if (!(Test-Admin)) {
    Write-Warning "Please Run This Script as Admin."
    Start-Sleep 10
    Exit
}

Start-Sleep -s 3

$pathsFilePath = "paths.txt"
if(-Not(Test-Path -Path $pathsFilePath)){
    Write-Warning "The file $pathsFilePath does not exist."
    Start-Sleep 10
    Exit
}

$paths = Get-Content "paths.txt"

$stopwatch = [Diagnostics.Stopwatch]::StartNew()

$results = @()

foreach ($path in $paths) {

    $fileName = Split-Path $path -Leaf
    Write-Host $path -ForegroundColor Blue
    $signatureStatus = (Get-AuthenticodeSignature $path 2>$null).Status
    
    $fileDetails = New-Object PSObject
    $fileDetails | Add-Member Noteproperty Name $fileName
    $fileDetails | Add-Member Noteproperty Path $path
    $fileDetails | Add-Member Noteproperty SignatureStatus $signatureStatus

    $results += $fileDetails
}

$results | Out-GridView -PassThru -Title 'Signatures Results'
$stopwatch.Stop()

$time = $stopwatch.Elapsed.Hours.ToString("00") + ":" + $stopwatch.Elapsed.Minutes.ToString("00") + ":" + $stopwatch.Elapsed.Seconds.ToString("00") + "." + $stopwatch.Elapsed.Milliseconds.ToString("000")

Write-Host ""
Write-Host "The scan took $time to run." -ForegroundColor Yellow
