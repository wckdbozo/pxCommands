# Changelog

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
- pxCommands event namespace throughout
- Enhanced SECURITY.md policy
- Contributing guidelines

### Changed
- Rebranded from `chat_commands` to `pxCommands`
- Updated repository to https://github.com/CodeMeAPixel/pxCommands
- Contact updated to hey@codemeapixel.dev
- Version system now checks GitHub Releases API instead of local file
- Autoupdate redirects to GitHub releases instead of file updates
- Documentation reorganized: `.github/` for repo docs, `docs/` for guides
- Replaced global `SETTINGS` with structured `Config` table
- settings.lua now acts as override/customization file instead of config source
- Improved framework detection with explicit export checking
- Enhanced logging with config-aware defaults
- README.md moved to .github/ (GitHub auto-discovers)

### Fixed
- Fixed variable scope issue in ESX command registration (raw variable)
- QBCore initialization now properly checks for export existence before use
- Removed busy-wait loops in version check
- Dead links and outdated documentation removed
- Updated all doc cross-references to point to correct paths

### Removed
- Static version file from version checks (now uses GitHub releases)
- vRP compatibility (deprecated; use ESX, QBCore, or QBox)
- Old toxicdev.me documentation references
- Corrupted dual-content in README
