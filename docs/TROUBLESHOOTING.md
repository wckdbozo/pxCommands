# Troubleshooting

## Commands Not Appearing

**Problem**: `/command` returns "Unknown command"

**Check**:
1. Is the resource started? Run `status` in the server console
2. Does `commands/` contain `.lua` files?
3. Check server logs for `Registering command` messages
4. Restart with `restart pxCommands`

## Admin Commands Work for Everyone

**Problem**: Players without admin can use admin-gated commands

**Solution**: `Config.AdminCheck` is `nil` by default. Set it in `system/config.lua`:

```lua
Config.AdminCheck = function(source)
    if Config.Framework == 'esx' and ESX then
        local player = ESX.GetPlayerFromId(source)
        return player and player.getGroup() == 'admin'
    end
    if Config.Framework == 'qbcore' and QBCore then
        local player = QBCore.Functions.GetPlayer(source)
        return player and player.PlayerData.job.name == 'police'
    end
    return IsPlayerAceAllowed(source, "command")
end
```

## Character Name Not Showing

**Problem**: `#char#` shows username instead of character name

**Requirements**:
- `Config.Formatting.useFrameworkName = true`
- ESX: `mysql-async` or `oxmysql` running and `users` table populated
- QBCore/QBox: Player data fully loaded (not in character select)

## Proximity Chat Sending to Everyone

**Problem**: Commands with `range` still broadcast globally

**Cause**: The server-side ped may not be valid at dispatch time (player not fully spawned)

**Check**: Ensure the player is spawned before running the command. The handler guards against a nil/zero ped and skips the message if so.

## ESX Character Name Shows Blank

**Problem**: `#char#` renders as an empty string

**Cause**: MySQL returned an empty result for the player's identifier

**Check**:
1. Verify `GetPlayerIdentifiers(source)` returns a valid identifier
2. Confirm the user row exists in the `users` table
3. Ensure `firstname` and `lastname` columns are not NULL

## Cooldown Firing for Admins

**Problem**: Admins are still subject to command cooldowns

**Solution**: Ensure `Config.AdminCheck` is configured and returns `true` for admin players. The cooldown bypass only activates when `Config.AdminCheck` is set.

## Webhook Not Sending

**Problem**: Discord embeds not appearing

**Check**:
1. `Config.Webhook.enabled = true`
2. `Config.Webhook.url` is a valid Discord webhook URL
3. If `Config.Webhook.handler` is set, the `url` field is ignored — use one or the other
4. Check server console for HTTP errors from `PerformHttpRequest`

## MySQL Errors on Startup

**Problem**: Console shows MySQL-related errors but commands still work

**This is expected**: MySQL usage is optional and guarded. The resource continues without it. ESX character name lookup falls back to the FXServer player name silently.

**To use MySQL**: Ensure `mysql-async` or `oxmysql` is `ensure`d before `pxCommands` in `server.cfg`.

## Version Check Fails

**Problem**: Startup shows an error or always reports outdated

**Possible causes**:
1. No GitHub releases tagged yet
2. Server has no outbound internet access
3. GitHub API rate limit hit

Set `Config.CheckUpdates = false` to disable.

## Commands Registered Twice

**Problem**: Logs show duplicate registrations for the same command

**Cause**: Same command name defined in multiple pack files

**Fix**: Ensure unique `command` values across all files in `commands/`

## Uninstalling or Updating

1. `stop pxCommands`
2. Replace the resource folder with the new version (use the zip from GitHub Releases or `build.ps1`)
3. `start pxCommands`
