# Architecture

## Structure

```
system/
├── config.lua                   Shared configuration table
├── server/
│   ├── pre.lua                  Initialization, framework setup, helpers
│   └── commands.lua             Command registration and handler
└── versioncheck.lua             Update checking and autoupdate
modules/
├── cl_overhead_text.lua         Floating 3D text above players
└── cl_notifications.lua         Screen notification module
commands/
├── example.lua                  Example command pack
├── roleplay.lua                 Built-in RP commands (/me, /do, /ooc, etc.)
└── admin.lua                    Built-in admin commands (/announce, /kick, etc.)
```

## Execution Order

1. `system/config.lua` — Config table initialized (shared)
2. `system/server/pre.lua` — Helpers, framework init, `COMMANDS` table, `CommandPack` defined
3. `commands/*.lua` — All command packs registered into `COMMANDS`
4. `system/server/commands.lua` — Commands registered with FXServer, handler logic
5. `system/versioncheck.lua` — Async update check

**Client:** `modules/cl_*.lua` loads independently after `system/config.lua`

## Data Flow

### Command Execution

```
Player types /command args
      ↓
RegisterCommand handler fires
      ↓
commandHandler: prereq → permission → cooldown → arg validation
      ↓
Name resolution (sync for QBCore, async for ESX)
      ↓
formatString substitutes #tokens#
      ↓
Global broadcast or server-side proximity filter
      ↓
cb / onCommandExecuted / sendWebhook
```

### Proximity Filtering

All proximity filtering is server-side. `triggerProximityMessage` iterates
`GetPlayers()`, measures distance between peds, and sends `chat:addMessage`
only to players within range. No client event is involved.

### Notifications

```
TriggerClientEvent("pxc:notify", targetId, message, type)
      ↓
cl_notifications.lua draws a NUI notification with color prefix
```

## Configuration

Config is a global shared table. Modify in `system/config.lua`.

## Security Model

- **Server-side validation** — All checks (admin, cooldown, args) enforced on server
- **Admin callback** — `Config.AdminCheck(source)` allows custom logic
- **prereq vs permission** — `prereq` failures are silent; permission failures show `noperm`
- **Audit hooks** — `onCommandExecuted` and `onCommandFailed` for full observability
- **Net event guards** — `pxc:showFloatingText` and `pxc:notify` reject client-relayed calls
- **Webhook logging** — Optional Discord embed or custom handler via `Config.Webhook`

## Framework Integration

### ESX
- Admin commands registered via `es:addGroupCommand`
- Framework object via `exports['es_extended']:getSharedObject()` with legacy event fallback
- Character name fetched async via `MySQL.Async.fetchAll`

### QBCore/QBox
- Player object via `QBCore.Functions.GetPlayer(source)`
- Character info from `PlayerData.charinfo`
- Admin check via ACL or `Config.AdminCheck`

### Standalone
- Admin checks use FXServer ACL (`IsPlayerAceAllowed`)
- Player name from `GetPlayerName(source)`

## Extending pxCommands

### Custom Command Packs

```lua
CommandPack("MyPack", "AuthorName", {
    {
        command  = "mycommand",
        help     = "My custom command",
        format   = "#name# did something: #message#",
        cooldown = 5,
        cb = function(source, message, command, args, raw)
        end
    }
})
```

See [COMMAND_PACKS.md](./COMMAND_PACKS.md) for full field reference.

### Custom Modules

Client modules are auto-loaded by the `modules/cl_*.lua` glob. Add a file matching
that pattern and it will be included automatically — no manifest changes required.

For server modules, add them manually to `fxmanifest.lua`:

```lua
server_scripts {
    'system/server/pre.lua',
    'commands/*.lua',
    'modules/sv_mymodule.lua',
    'system/server/commands.lua',
    'system/versioncheck.lua'
}
```

### Custom Admin Logic

```lua
Config.AdminCheck = function(source)
    return exports['your-acl']:isAdmin(source)
end
```

### Command Hooks

```lua
Config.Callbacks.onCommandExecuted = function(source, message, command, args, raw)
    if command.admin then
        TriggerEvent('audit:log', {
            action  = 'command',
            player  = GetPlayerName(source),
            command = command.command,
            args    = args,
        })
    end
end

Config.Callbacks.onCommandFailed = function(source, reason, command, args, raw)
    -- reason: "prereq" | "permission" | "cooldown" | "invalid_args" | "no_args"
end
```

## Performance

- Framework detection runs once at startup
- No periodic polling; fully event-driven
- Proximity filtering done server-side — only recipients get the network event
- ESX name lookup is async (non-blocking)
- `cl_overhead_text.lua` thread yields at 500ms when no entries are active
- Cooldown tracker cleaned up on `playerDropped`

## Known Limitations

- Command names must be unique across all packs
- Proximity is range-based sphere, not line-of-sight
- vRP not supported

## Version Management

- Version read from `fxmanifest.lua` via `GetResourceMetadata`
- Compared against GitHub Releases API using semantic versioning
- Set `Config.CheckUpdates = false` to disable
- Use `/pxCommands autoupdate` to check manually

## References

- [SECURITY.md](../.github/SECURITY.md)
- [CONTRIBUTING.md](../.github/CONTRIBUTING.md)
