# Configuration Reference

All config options are defined in `system/config.lua`. Edit this file directly to customize behavior.

## Framework Selection

```lua
Config.Framework = 'standalone'
```

Available values:
- `'esx'` — ESX framework
- `'qbcore'` — QBCore framework
- `'qbox'` — QBox framework
- `'standalone'` — No framework (FXServer ACL only)

## Logging

```lua
Config.Logging = true
```

Enable/disable server console logging of command registration and startup.

## Version Checking

```lua
Config.CheckUpdates = true
```

Enable/disable automatic checking for updates against GitHub releases at startup. Use `/pxCommands autoupdate` to manually check.

## Admin Permission

```lua
Config.AdminCheck = function(source)
    return IsPlayerAceAllowed(source, "command")
end
```

Custom function to determine if a player is an admin. Receives source (player ID), returns boolean.

This is called when `command.admin = true`. Default behavior:
- **ESX**: Checks player group == 'admin'
- **QBCore/QBox**: Checks player gang/job
- **Standalone**: Checks FXServer ACL

Override this to use custom admin systems.

## Formatting Options

### useFrameworkName

```lua
Config.Formatting.useFrameworkName = true
```

When true, uses character/framework name in `#name#` and `#char#` placeholders. When false, uses player username.

Only works with ESX (MySQL) or QBCore/QBox (player object).

### showPlayerId

```lua
Config.Formatting.showPlayerId = true
```

When true, appends player server ID in parentheses to names:
```
John Doe (42)
```

## Callbacks

### onCommandExecuted

```lua
Config.Callbacks.onCommandExecuted = function(source, message, command, args, raw)
    -- Fire after any command executes
end
```

Useful for logging, analytics, or triggering side effects.

Parameters:
- `source`: Player ID
- `message`: Formatted command message
- `command`: Command definition table
- `args`: Argument table (split by spaces)
- `raw`: Raw input string from RegisterCommand



## Example Override

Edit `system/config.lua`:

```lua
Config.Framework = 'qbcore'
Config.Logging = false
Config.CheckUpdates = false

Config.AdminCheck = function(source)
    local player = exports['qb-core']:GetPlayer(source)
    return player and player.PlayerData.job.grade.name == 'boss'
end

Config.Formatting.useFrameworkName = true
Config.Formatting.showPlayerId = false

Config.Callbacks.onCommandExecuted = function(source, message, command, args, raw)
    exports['qb-log']:logCommand(source, command.command, args)
end
```
