param()

$stdinContent = ""
try {
    if ([Console]::IsInputRedirected) { $stdinContent = [Console]::In.ReadToEnd() }
} catch { exit 0 }

try { $event = $stdinContent | ConvertFrom-Json } catch { exit 0 }

$toolName = $event.tool_name
if (-not $toolName) { exit 0 }

$markerFile = "$env:TEMP\claude-perm-$toolName.pending"
Remove-Item $markerFile -Force -ErrorAction SilentlyContinue

exit 0
