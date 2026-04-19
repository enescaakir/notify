# notify

Claude Code plugin for Windows — fires toast notifications and audio on permission requests and task completion.

## Events

| Hook | When | Behavior |
|------|------|----------|
| `PreToolUse` | Tool called | Starts 3s delayed notification |
| `PostToolUse` | Tool completes (auto-approved) | Cancels pending notification |
| `Stop` | Task completed | Toast: "Task completed." |

## How Permission Detection Works

`notify-permission.ps1` fires on every `PreToolUse`:

1. Writes a marker file to `%TEMP%\claude-perm-<tool>.pending`
2. Starts a background process that waits 3 seconds, then checks if the marker still exists
3. `notify-post.ps1` fires on `PostToolUse` — removes the marker immediately

If the tool is auto-approved, `PostToolUse` removes the marker before the 3s window expires → no notification. If the tool needs user permission, the user sees the prompt while the 3s passes → toast fires.

## Requirements

- Windows (uses WPF + Windows toast APIs)
- [BurntToast](https://github.com/Windos/BurntToast) PowerShell module

```powershell
Install-Module BurntToast -Scope CurrentUser
```

## Installation

Install via Claude Code plugin manager, or copy this folder into your plugins directory. The plugin harness resolves `${CLAUDE_PLUGIN_ROOT}` automatically.

## Customization

Edit `hooks/hooks.json` to change `-Title`, `-Message`, or `-Sound` for each event. Sound must be a path to a `.wav` file.

## License

MIT - i'm freeeeEEeee