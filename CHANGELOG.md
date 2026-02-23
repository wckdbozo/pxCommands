# Changelog

## [0.2.0] — 02-22-2026

### Added
- `Config.Callbacks.onCommandFailed` callback with reason string: `prereq`, `permission`, `cooldown`, `invalid_args`, `no_args`
- `Config.Cooldowns.default` global cooldown setting; per-command override via `cooldown` field
- `Config.Webhook` block: Discord embed logging via `url`, or fully custom `handler` function
- Server-side proximity distance filtering — only players within range receive the chat event
- `AddCommandAlias(alias, commandName)` global function for use in command packs loaded after pre.lua
- Argument type validation: `number`, `playerId`, `string` (with `minLength`/`maxLength`)
- Admin bypass for per-command cooldowns when `Config.AdminCheck` is configured
- `lua54 'yes'` in fxmanifest for Lua 5.4 performance improvements
- `commands/roleplay.lua` pack: `/me`, `/do`, `/ooc`, `/tweet`, `/911`, `/low`, `/shout` with pre-configured ranges, cooldowns, and colors
- `commands/admin.lua` pack: `/announce`, `/staffchat`, `/kick`, `/warn` (all admin-gated)
- `modules/cl_notifications.lua`: screen notification module with `success`, `error`, `warning`, `info` types; triggered via `pxc:notify` (server→client) or `pxc:notifyLocal` (client→self)

### Changed
- ESX framework init now uses `exports['es_extended']:getSharedObject()` (non-blocking) with legacy event fallback
- ESX name lookup switched from `MySQL.Sync.fetchAll` (blocking) to `MySQL.Async.fetchAll`
- `CommandPack` defaults now use nil-check instead of falsy-check, preserving explicit `false` values (e.g. `hidden = false`)
- `fail()` in commandHandler only shows `noperm` message on actual permission/admin failures, not prereq failures
- `shallowcopy` now deep-copies nested tables so command aliases don't share references (e.g. `args`)
- `formatString` helper replaces duplicated token substitution logic for both `format` and `title` fields
- `pxc:showFloatingText` client event now rejects relayed client-to-client calls

### Fixed
- Overhead text render loop used `table.remove` inside forward iteration, causing skipped entries on removal
- Overhead text thread spun at `Wait(0)` even with no active floating text entries
- `GetResourceMetadata` called with 2 arguments instead of the required 3
- `triggerProximityMessage` guard added for nil `tonumber()` result
- Proximity chat broadcast sent to all clients; now filtered server-side before dispatch
- `/warn` admin command nil-guarded `targetId` before passing to `TriggerClientEvent`

## [0.1.0] — 02-09-2026

### Added
- GitHub Releases-based version checking (replaces local version file)
- Development build detection ("dev" when no releases exist)
- GitHub API integration for update checking and autoupdate
- Comprehensive documentation reorganization (.github/, docs/)
- MIGRATION.md guide in docs/ for upgrade path from chat_commands
- Proper system/config.lua with structured Config table
- `Config.Framework` single string field for framework selection (replaces booleans)
- `Config.Formatting.*` for show_id and useFrameworkName options
- `Config.Callbacks.onCommandExecuted` hook for command audit logging
- `Config.AdminCheck` callback for custom admin logic
- Example command pack in `commands/example.lua`
- QBCore export validation to prevent nil errors
- Modern `fxmanifest.lua` (cerulean format)
- Support for ESX, QBCore, QBox, and standalone frameworks
- Modular architecture with clean separation of concerns
- pxc event namespace throughout
- Enhanced SECURITY.md policy
- Contributing guidelines
- Complete user guides: GETTING_STARTED.md, COMMAND_PACKS.md, CONFIG_REFERENCE.md, TROUBLESHOOTING.md
- docs/README.md navigation hub for documentation

### Changed
- Rebranded from `chat_commands` to `pxCommands`
- Updated repository to https://github.com/CodeMeAPixel/pxCommands
- Contact updated to hey@codemeapixel.dev
- Version system now checks GitHub Releases API instead of local file
- Autoupdate redirects to GitHub releases instead of file updates
- Documentation reorganized: `.github/` for repo docs, `docs/` for guides
- Replaced global `SETTINGS` with structured `Config` table
- Improved framework detection with explicit export checking
- Enhanced logging with config-aware defaults
- README.md moved to .github/ (GitHub auto-discovers)
- Event namespace shortened to `pxc:*` (pxc:proximity, pxc:showFloatingText)
- Fixed script execution order in fxmanifest.lua
- Removed settings.lua override file; configuration now directly in system/config.lua
- Removed FXServer version check system (no longer required)

### Fixed
- Fixed variable scope issue in ESX command registration (raw variable)
- QBCore initialization now properly checks for export existence before use
- Removed busy-wait loops in version check
- Dead links and outdated documentation removed
- Updated all doc cross-references to point to correct paths
- Fixed Lua type diagnostics: SetTextProportional and SetTextCentre now use boolean instead of integer
- Fixed GetDistanceBetweenCoords last parameter type (boolean instead of integer)
- Added MySQL type annotation to prevent undefined global diagnostics
- Fixed command registration execution order (pre.lua → commands/*.lua → commands.lua)

### Removed
- Static version file from version checks (now uses GitHub releases)
- vRP compatibility (deprecated; use ESX, QBCore, or QBox)
- Old toxicdev.me documentation references
- Corrupted dual-content in README
- FXServer version check enforcement (fxcheck_1226.lua)
- settings.lua configuration file (use system/config.lua directly)
- Dynamic module auto-loading (sv_*.lua, sh_*.lua patterns)

