# Architecture

## Structure

```
system/
├── config.lua                   Shared configuration table
├── server/
│   ├── pre.lua                  Initialization, framework setup, helpers
│   └── commands.lua             Command registration and handler
├── client/
│   └── proximity.lua            Range-based message broadcast
└── versioncheck.lua             Update checking and autoupdate
modules/
└── cl_*.lua                     Client modules (auto-loaded)
commands/
└── *.lua                        Command packs (auto-loaded)
```

## Execution Order

1. `fxmanifest.lua` loads all scripts in order
2. `system/config.lua` initializes Config table

**Client:** `modules/cl_*.lua` client modules load in parallel with server

## Data Flow

### Command Execution

```
Player types /command args
      ↓
RegisterCommand handler fires
      ↓
commandHandler validates and processes
      ↓
Framework checks (Admin, Permissions)
      ↓
Command callback or broadcast
      ↓
onCommandExecuted hook (if set)
```

### Message Broadcasting

**Global:**
`TriggerClientEvent("chat:addMessage")` → All players

**Proximity:**
`TriggerClientEvent("pxc:proximity")` → Server triggers client proximity check

## Configuration

Config is a global shared table. Modify in `system/config.lua`.

## Security Model

- **Server-side validation** — All admin/permission checks enforced on server
- **Admin callback** — `Config.AdminCheck(source)` allows custom logic
- **Framework delegation** — Admin checks delegate to ESX/QBCore if available
- **Audit hooks** — `Config.Callbacks.onCommandExecuted` logs all command use

## Framework Integration

### ESX
- Admin commands registered via `es:addGroupCommand`
- Player identity fetched from MySQL users table
- Character name used in formatting when available

### QBCore/QBox
- Player object retrieved via `QBCore.Functions.GetPlayer(source)`
- Character info from `PlayerData.charinfo`
- Admin check left to ACL/command definition

### Standalone
- All admin checks via FXServer ACL
- Player name from `GetPlayerName(source)`
- No framework-specific callbacks

## Extending pxCommands

### Custom Command Packs

The primary extension method is creating command packs in `commands/*.lua`:

```lua
CommandPack("MyCustom", "AuthorName", {
    {
        command = "mycommand",
        help = "My custom command",
        format = "#username# did something",
        cb = function(source, message, command, args, raw)
            -- Your custom logic here
        end
    }
})
```

See [COMMAND_PACKS.md](./COMMAND_PACKS.md) for detailed documentation.

### Custom Modules

To add custom server or shared modules, manually add them to `fxmanifest.lua`:

```lua
server_scripts {
    'system/server/pre.lua',
    'commands/*.lua',
    'modules/my_custom_module.lua',  -- Add here
    'system/server/commands.lua',
    'system/versioncheck.lua'
}
```

### Custom Admin Logic

```lua
Config.AdminCheck = function(source)
    -- Return true if player is admin
    return exports['your-acl']:isAdmin(source)
end
```

### Command Hooks

```lua
Config.Callbacks.onCommandExecuted = function(source, message, command, args, raw)
    if command.admin then
        TriggerEvent('audit:log', {
            action = 'command',
            player = GetPlayerName(source),
            command = command.command,
            args = args,
        })
    end
end
```

## Performance

- Framework detection runs once at startup
- No periodic polling; event-driven
- Command handler is lightweight (no loops)
- Proximity check runs only for ranged messages
- Identity lookups cached by game engine

## Known Limitations

- Command names must be unique (no duplication across packs)
- Proximity calculation is range-based, not los-based
- vRP not supported (use ESX, QBCore, QBox, or standalone)

## Version Management

The resource uses GitHub releases for version tracking:

- **Production builds**: Tagged releases on GitHub (e.g., `v1.0.0`)
- **Development builds**: Identified as "dev" if no releases exist
- **Version check**: Automatic HTTP request to GitHub Releases API at startup
- **Autoupdate**: Command-based update that directs to latest release download

Set `Config.CheckUpdates = false` to disable automatic version checking.

## References

- [MIGRATION.md](MIGRATION.md) — Upgrade from chat_commands
- [SECURITY.md](../.github/SECURITY.md) — Security policies
- [CONTRIBUTING.md](../.github/CONTRIBUTING.md) — Development guidelines
