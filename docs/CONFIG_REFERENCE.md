# Configuration Reference

All config options are defined in `system/config.lua`. Edit this file directly to customize behavior.

## Framework

```lua
Config.Framework = 'standalone'
```

| Value | Description |
|-------|-------------|
| `'esx'` | ESX — group commands, async character name lookup |
| `'qbcore'` | QBCore — player object, charinfo |
| `'qbox'` | QBox — same as QBCore |
| `'standalone'` | FXServer ACL only |

## Logging

```lua
Config.Logging = true
```

Enables server console output for startup, command registration, and update checks.

## Version Checking

```lua
Config.CheckUpdates = true
```

Checks the GitHub Releases API at startup and logs whether the resource is up to date. Version is read from `fxmanifest.lua`. Use `/pxCommands autoupdate` to check manually.

## Admin Check

```lua
Config.AdminCheck = function(source)
    return IsPlayerAceAllowed(source, "command")
end
```

Called when `command.admin = true`. Return `true` to allow, `false` to deny. Also used to bypass per-command cooldowns for admins.

Default (if nil): standalone ACL only.

## Formatting

```lua
Config.Formatting = {
    showPlayerId      = true,
    useFrameworkName  = true,
}
```

### `showPlayerId`
Appends the server ID in parentheses to names in `#name#`, `#username#`:
```
John Doe (42)
```

### `useFrameworkName`
Uses character name from the framework in `#name#` and `#char#` placeholders. ESX fetches from MySQL async; QBCore/QBox reads from the player object. Falls back to FXServer player name if unavailable.

## Cooldowns

```lua
Config.Cooldowns = {
    default = 0,
}
```

Global per-command cooldown in seconds. `0` disables it. Override per command:

```lua
{ command = "me", cooldown = 1, ... }
```

Admins bypass cooldowns when `Config.AdminCheck` is configured.

## Webhook Logging

```lua
Config.Webhook = {
    enabled = false,
    url     = "",
    handler = nil,
}
```

Logs every successful command execution.

### Discord (built-in)

Set `enabled = true` and provide a Discord webhook URL:

```lua
Config.Webhook = {
    enabled = true,
    url     = "https://discord.com/api/webhooks/...",
}
```

### Custom handler

Set `handler` to a function to use your own logging system. When set, `url` is ignored entirely:

```lua
Config.Webhook = {
    enabled = true,
    handler = function(source, message, command, args)
        exports['my-logger']:log(source, command.command, message)
    end,
}
```

## Callbacks

### `onCommandExecuted`

```lua
Config.Callbacks.onCommandExecuted = function(source, message, command, args, raw)
end
```

Fires after every successful command broadcast.

### `onCommandFailed`

```lua
Config.Callbacks.onCommandFailed = function(source, reason, command, args, raw)
end
```

Fires when a command is blocked. `reason` values:

| Value | Cause |
|-------|-------|
| `prereq` | `command.prereq` returned false |
| `permission` | `Config.AdminCheck` returned false |
| `cooldown` | Player triggered cooldown |
| `invalid_args` | Argument type or length validation failed |
| `no_args` | Command requires args but none were given |

## Full Example

```lua
Config.Framework = 'qbcore'
Config.Logging   = false

Config.AdminCheck = function(source)
    local player = exports['qb-core']:GetCoreObject().Functions.GetPlayer(source)
    return player and player.PlayerData.job.grade.name == 'boss'
end

Config.Formatting.useFrameworkName = true
Config.Formatting.showPlayerId     = false

Config.Cooldowns.default = 1

Config.Webhook = {
    enabled = true,
    handler = function(source, message, command, args)
        exports['qb-log']:logCommand(source, command.command, args)
    end,
}

Config.Callbacks.onCommandFailed = function(source, reason, command)
    if reason == 'permission' then
        TriggerClientEvent('pxc:notify', source, 'Access denied.', 'error')
    end
end
```
