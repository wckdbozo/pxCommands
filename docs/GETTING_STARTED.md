# Getting Started

## Installation

1. Clone or download the resource into your resources folder
2. Add to `server.cfg`:
   ```
   ensure pxCommands
   ```
3. Start or restart your server

## Configuration

Basic setup in `system/config.lua`:

```lua
Config.Framework = 'esx'  -- 'esx', 'qbcore', 'qbox', or 'standalone'
Config.CheckUpdates = true
Config.Logging = true

Config.AdminCheck = function(source)
    if Config.Framework == 'esx' and ESX then
        local player = ESX.GetPlayerFromId(source)
        return player and player.getGroup() == 'admin'
    end
    return IsPlayerAceAllowed(source, "command")
end
```

## Creating Your First Command Pack

Create `commands/mycommands.lua`:

```lua
CommandPack("MyCommands", "myauthor", {
    {
        command = "hello",
        help = "Say hello to the server",
        format = "#username# says hello!",
        admin = false,
        cb = function(source, message, command, args, raw)
            print(message)
        end
    }
})
```

Reload scripts and type `/hello` to test.

## Available Frameworks

- **ESX** — Uses es:addGroupCommand for admin, fetches character names from database
- **QBCore/QBox** — Uses built-in player object, character info available
- **Standalone** — No framework features; uses FXServer ACL for admin

## Next Steps

- Read [COMMAND_PACKS.md](./COMMAND_PACKS.md) for detailed command options
- Read [ARCHITECTURE.md](./ARCHITECTURE.md) for technical details
- Check `commands/example.lua` for a full example
