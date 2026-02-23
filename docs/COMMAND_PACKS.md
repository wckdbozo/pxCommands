# Command Packs

A command pack is a Lua file that registers one or more commands. Each pack is loaded automatically from the `commands/` directory.

## Basic Structure

```lua
CommandPack("PackName", "AuthorName", commands, defaults, aliases)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `PackName` | string | Display name for logs |
| `AuthorName` | string | Author for logs |
| `commands` | table | Array of command definition tables |
| `defaults` | table | Optional default values applied to all commands in this pack |
| `aliases` | table | Optional `{{"alias", "target"}, ...}` pairs |

## Command Fields

### Required

| Field | Type | Description |
|-------|------|-------------|
| `command` | string | Command name (used as `/name`) |
| `format` | string | Message format. Required unless `reply` is set |

### Optional

| Field | Type | Description |
|-------|------|-------------|
| `help` | string | Help text shown in chat autocomplete |
| `usage` | string | Shown to the player when args are missing or invalid |
| `args` | table | Argument definitions (see below) |
| `title` | string | Message title prepended to formatted output |
| `color` | table | RGB color `{255, 0, 0}` |
| `admin` | boolean | Restrict to admins via `Config.AdminCheck` |
| `noperm` | string | Message shown on permission denial |
| `prereq` | function | Custom validation; return false to block silently |
| `noargs` | boolean | Allow execution with no arguments |
| `hidden` | boolean | Process the command but skip broadcasting the message |
| `range` | number | Proximity range in meters. Omit or use `-1` for global |
| `cooldown` | number | Per-player cooldown in seconds. Overrides `Config.Cooldowns.default` |
| `reply` | string | Static reply sent to the caller; skips all formatting |
| `cb` | function | Callback fired after message broadcast |

### Argument Definition Fields

Each entry in `args` is a table:

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Argument name (shown in autocomplete) |
| `help` | string | Argument description (shown in autocomplete) |
| `type` | string | `"number"`, `"playerId"`, or `"string"` — enables validation |
| `required` | boolean | Default `true`. Set to `false` to make optional |
| `minLength` | number | Minimum character length (type `"string"` only) |
| `maxLength` | number | Maximum character length (type `"string"` only) |

## Format Placeholders

Use these in `format` and `title` strings:

| Placeholder | Value |
|-------------|-------|
| `#username#` | FXServer player name |
| `#char#` | Character name from framework |
| `#name#` | Character name when available, otherwise username |
| `#id#` | Player server ID |
| `#message#` | All arguments joined with spaces |

`#name#` and `#char#` require `Config.Formatting.useFrameworkName = true` and a supported framework.

## Callbacks

### Command Callback (`cb`)

```lua
cb = function(source, message, command, args, raw)
    -- source:  player server ID
    -- message: fully formatted string after token substitution
    -- command: the command definition table
    -- args:    table of space-split argument strings
    -- raw:     raw input string from RegisterCommand
end
```

### Prerequisite Check (`prereq`)

Runs before permission and cooldown checks. Return `false` to abort silently (no `noperm` shown).

```lua
prereq = function(source, command, args, raw)
    return IsPlayerAceAllowed(source, "custom.permission")
end
```

### Global Hooks

Set in `system/config.lua`:

```lua
Config.Callbacks.onCommandExecuted = function(source, message, command, args, raw) end
Config.Callbacks.onCommandFailed   = function(source, reason, command, args, raw) end
-- reason: "prereq" | "permission" | "cooldown" | "invalid_args" | "no_args"
```

## Aliases

Register aliases in the `CommandPack` call or at any time via the global helper:

```lua
-- Via CommandPack
CommandPack("MyPack", "Author", commands, defaults, {
    {"tw", "tweet"},
    {"e",  "me"},
})

-- At any time after the target command is registered
AddCommandAlias("tw", "tweet")
```

## Pack Defaults

The `defaults` table applies values to every command in the pack that doesn't already define them. The check is `nil`-based, so `hidden = false` on a command is respected even if the default is `true`.

```lua
CommandPack("Chat", "Author", commands, {
    color    = {200, 200, 200},
    cooldown = 2,
})
```

## Examples

### Proximity Roleplay Command

```lua
{
    command  = "me",
    format   = "* #name# #message#",
    help     = "Perform a roleplay action",
    usage    = "/me [action]",
    color    = {255, 220, 100},
    range    = 25.0,
    cooldown = 1,
    args     = {{name = "action", help = "The action", type = "string", minLength = 1}},
}
```

### Admin-only Broadcast

```lua
{
    command  = "announce",
    format   = "[ANNOUNCEMENT] #message#",
    help     = "Broadcast to all players",
    color    = {255, 165, 0},
    admin    = true,
    noperm   = "You don't have permission.",
    cooldown = 10,
    args     = {{name = "message", help = "Announcement text", type = "string", minLength = 1}},
}
```

### Static Reply

```lua
{
    command = "motd",
    reply   = "Welcome to the server!",
    noargs  = true,
}
```

### Custom Validation

```lua
{
    command = "report",
    format  = "#username# submitted a report",
    prereq  = function(source)
        return IsPlayerAceAllowed(source, "report.submit")
    end,
    noperm = "You are not allowed to submit reports.",
    args   = {{name = "message", type = "string", minLength = 10}},
}
```

### Hidden Callback Command

```lua
{
    command = "staffchat",
    format  = "[STAFF] #name#: #message#",
    admin   = true,
    hidden  = true,
    cb      = function(source, message, command, args, raw)
        for _, id in ipairs(GetPlayers()) do
            local pid = tonumber(id)
            if pid and Config.AdminCheck and Config.AdminCheck(pid) then
                TriggerClientEvent("chat:addMessage", pid, {
                    color = {200, 100, 255},
                    args  = {message},
                })
            end
        end
    end,
}
```

## Built-in Packs

Two packs are included and loaded by default:

### `commands/roleplay.lua`
`/me`, `/do`, `/ooc`, `/tweet`, `/911`, `/low`, `/shout`

### `commands/admin.lua`
`/announce`, `/staffchat`, `/kick`, `/warn` — all require `Config.AdminCheck` to return true

You can disable either by removing or renaming the file.

## Conflict Resolution

Command names must be unique across all packs. If two packs define the same name, the first loaded wins and the duplicate is logged and skipped.

## Debug

Check server logs for:
- `Registering command /name from pack PackName by Author` — loaded successfully
- `Could not add /name: Missing format parameter` — malformed definition
