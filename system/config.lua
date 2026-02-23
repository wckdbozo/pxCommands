Config = {}

Config.Framework = "standalone"

Config.Logging = true

Config.CheckUpdates = true

Config.Callbacks = {
    onCommandExecuted = nil,
    onCommandFailed = nil,
}

Config.AdminCheck = nil

Config.Formatting = {
    showPlayerId = true,
    useFrameworkName = true,
}

Config.Cooldowns = {
    default = 0,
}

Config.Webhook = {
    enabled = false,
    url = "",
    handler = nil,
}
