param()

$stdinContent = ""
try {
    if ([Console]::IsInputRedirected) { $stdinContent = [Console]::In.ReadToEnd() }
} catch { exit 0 }

if (-not $stdinContent) { exit 0 }

try { $event = $stdinContent | ConvertFrom-Json } catch { exit 0 }

$toolName = $event.tool_name
if (-not $toolName) { exit 0 }

$markerFile = "$env:TEMP\claude-perm-$toolName.pending"
Set-Content $markerFile $toolName -Force

$Logo = Join-Path $env:CLAUDE_PLUGIN_ROOT "assets\claude-logo.jpg"
$Sound = "C:\Windows\Media\Windows Proximity Notification.wav"

$notifyBlock = @"
Start-Sleep -Seconds 3
if (Test-Path '$markerFile') {
    Remove-Item '$markerFile' -Force -ErrorAction SilentlyContinue
    try {
        Import-Module BurntToast -ErrorAction Stop
        `$msg = 'Permission request: $toolName'
        if (Test-Path '$Logo') {
            New-BurntToastNotification -Text 'Claude AI - Permission', `$msg -AppLogo '$Logo' -Silent
        } else {
            New-BurntToastNotification -Text 'Claude AI - Permission', `$msg -Silent
        }
        if (Test-Path '$Sound') {
            Add-Type -AssemblyName PresentationCore
            `$p = New-Object System.Windows.Media.MediaPlayer
            `$p.Open([Uri]'$Sound')
            `$p.Play()
            Start-Sleep -Seconds 3
        }
    } catch { }
}
"@

Start-Process powershell.exe -WindowStyle Hidden -ArgumentList @(
    "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $notifyBlock
)

exit 0
