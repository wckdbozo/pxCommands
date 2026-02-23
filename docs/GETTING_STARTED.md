# Getting Started

## Installation

1. Download the latest release from [GitHub Releases](https://github.com/CodeMeAPixel/pxCommands/releases) or use the build script (see below)
2. Extract the `pxCommands` folder into your server's `resources/` directory
3. Add to `server.cfg`:
   ```
   ensure pxCommands
   ```
4. Start or restart your server

## Building from Source

A PowerShell build script is included to generate a clean deployable copy:

```powershell
.\build.ps1
```

Outputs:
- `dist/pxCommands/` — unzipped resource ready to drop into your server
- `dist/pxCommands-vX.X.X.zip` — zipped release archive

The version is read automatically from `fxmanifest.lua`. You can also pass it explicitly:

```powershell
.\build.ps1 -Version "1.0.0"
```

## Configuration

Open `system/config.lua` and set your framework:

```lua
Config.Framework = 'esx'  -- 'esx', 'qbcore', 'qbox', or 'standalone'
```

Configure an admin check to gate admin commands:

```lua
Config.AdminCheck = function(source)
    if Config.Framework == 'esx' and ESX then
        local player = ESX.GetPlayerFromId(source)
        return player and player.getGroup() == 'admin'
    end
    return IsPlayerAceAllowed(source, "command")
end
```

## Built-in Command Packs

Two packs are included and active by default:

### Roleplay (`commands/roleplay.lua`)

| Command | Description | Range |
|---------|-------------|-------|
| `/me` | Roleplay action | 25m |
| `/do` | Describe environment | 25m |
| `/low` | Whisper | 5m |
| `/shout` | Shout | 75m |
| `/ooc` | Out of character | Global |
| `/tweet` | Post a tweet (280 char max) | Global |
| `/911` | Call emergency services | Global |

### Admin (`commands/admin.lua`)

| Command | Description |
|---------|-------------|
| `/announce` | Broadcast to all players |
| `/staffchat` | Message visible only to admins |
| `/kick` | Kick a player with reason |
| `/warn` | Send a warning notification to a player |

All admin commands require `Config.AdminCheck` to return `true` for the caller.

To disable a pack, delete or rename the file. To create your own, see [COMMAND_PACKS.md](./COMMAND_PACKS.md).

## Notifications

`modules/cl_notifications.lua` is a client notification module. Trigger it from server-side:

```lua
TriggerClientEvent("pxc:notify", source, "Your message", "success")
```

Types: `success`, `error`, `warning`, `info`

## Creating Your First Command Pack

Create `commands/mycommands.lua`:

```lua
CommandPack("MyCommands", "myauthor", {
    {
        command  = "hello",
        help     = "Say hello to the server",
        format   = "#name# says hello!",
        cooldown = 5,
    }
})
```

Restart the resource and type `/hello` to test.

## Next Steps

- [COMMAND_PACKS.md](./COMMAND_PACKS.md) — full command field reference
- [CONFIG_REFERENCE.md](./CONFIG_REFERENCE.md) — all config options
- [ARCHITECTURE.md](./ARCHITECTURE.md) — internals and extension points
