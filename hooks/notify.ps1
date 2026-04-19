param(
    [string]$Title = "Claude AI",
    [string]$Message = "Waiting for your attention",
    [string]$Sound = "C:\Windows\Media\Windows Proximity Notification.wav"
)

$Logo = Join-Path $env:CLAUDE_PLUGIN_ROOT "assets\claude-logo.jpg"

try {
    if (Test-Path $Sound) {
        Start-Process -WindowStyle Hidden powershell.exe -ArgumentList @(
            "-NoProfile",
            "-Command",
            "Add-Type -AssemblyName PresentationCore; `$p = New-Object System.Windows.Media.MediaPlayer; `$p.Open([Uri]'$Sound'); `$p.Play(); Start-Sleep -Seconds 3"
        )
    }
    Import-Module BurntToast -ErrorAction Stop
    if (Test-Path $Logo) {
        New-BurntToastNotification -Text $Title, $Message -AppLogo $Logo -Silent
    } else {
        New-BurntToastNotification -Text $Title, $Message -Silent
    }
} catch {
    exit 0
}
exit 0