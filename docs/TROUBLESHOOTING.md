# Troubleshooting

## Commands Not Appearing

**Problem**: `/command` returns "Unknown command"

**Check**:
1. Is the resource started? `status` in server console
2. Does `commands/` folder exist with `.lua` files?
3. Check server logs for `Registering command` messages
4. Restart with `restart pxCommands`

## Permissions Not Working

**Problem**: Admin commands work for everyone

**Solution**: Configure `Config.AdminCheck` in `system/config.lua`:

```lua
Config.AdminCheck = function(source)
    -- ESX
    if Config.Framework == 'esx' and ESX then
        local player = ESX.GetPlayerFromId(source)
        return player and player.getGroup() == 'admin'
    end
    -- QBCore
    if Config.Framework == 'qbcore' and QBCore then
        local player = QBCore.Functions.GetPlayer(source)
        return player and player.PlayerData.job.name == 'police'
    end
    -- Fallback
    return IsPlayerAceAllowed(source, "command")
end
```

## Character Name Not Showing

**Problem**: `#char#` shows username instead of character name

**Requirements**:
- `Config.Formatting.useFrameworkName = true`
- ESX: MySQL-async running and users table accessible
- QBCore/QBox: Player data loaded

**Check**:
- Is ESX character selection working?
- Does MySQL have user data populated?
- Is player fully loaded (not in character select)?

## Proximity Chat Broadcasting to Everyone

**Problem**: `range = 30` messages still broadcast globally

**Cause**: Client-side proximity handler not loaded

**Fix**: Ensure `system/client/proximity.lua` is loaded. Check server logs.

## MySQL Query Errors

**Problem**: Console shows "MySQL not initialized" but resource works

**This is normal**: MySQL-async is optional. The resource guards its usage and continues without it.

**To use MySQL**: Ensure `mysql-async` is `ensure`d before `pxCommands` in server.cfg

## ESX Character Name Shows Empty

**Problem**: `#char#` shows blank space

**Cause**: MySQL fetch returned empty result

**Check**:
1. Is identifier correct? Check `GetPlayerIdentifiers(source)`
2. Does user exist in database?
3. Is firstname/lastname populated (not NULL)?

## FXServer Version Warning

**Problem**: Server console shows "Unsupported FXServer version"

**Solution**: Update FXServer to build 1226 or newer

## Commands Loaded Twice

**Problem**: Command registered twice (logs show duplicate registrations)

**Cause**: Same command defined in multiple pack files

**Fix**: Ensure unique command names across all `commands/` files

## Framework Not Detected

**Problem**: `Config.Framework` shows as detected but features fail

**Solution**: Check `system/config.lua` settings:

```lua
Config.Framework = 'esx'  -- Explicitly set the framework
```

Do not rely on auto-detection if overriding in settings.

## Version Check Fails

**Problem**: `/pxCommands autoupdate` shows error

**Possible causes**:
1. No GitHub releases tagged yet (run `git tag v0.1.0` and push)
2. Server has no internet access
3. Rate-limited by GitHub API

**Check**: Enable `Config.Logging = true` and review startup messages

## Uninstalling or Updating

1. Stop resource: `stop pxCommands`
2. Replace resource folder with new version
3. Start: `start pxCommands`
