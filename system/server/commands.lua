MySQL = MySQL or {}

local cooldownTracker = {}

AddEventHandler('playerDropped', function()
    cooldownTracker[source] = nil
end)

local function formatString(template, source, visualId, visualName, argMessage)
    local playerName = GetPlayerName(source) or "Unknown"
    local nameWithId = visualName .. " (" .. tostring(visualId) .. ")"
    local userWithId = playerName .. " (" .. tostring(visualId) .. ")"
    local str = template
    str = str:gsub("#username#", Config.Formatting.showPlayerId and userWithId or playerName)
    str = str:gsub("#char#",     visualName)
    str = str:gsub("#name#",     Config.Formatting.showPlayerId and nameWithId or visualName)
    str = str:gsub("#id#",       tostring(visualId))
    str = str:gsub("#message#",  argMessage)
    return str
end

local function triggerProximityMessage(source, range, payload)
    local srcPed = GetPlayerPed(source)
    if not srcPed or srcPed == 0 then return end
    local srcPos = GetEntityCoords(srcPed)
    for _, playerId in ipairs(GetPlayers()) do
        local pid = tonumber(playerId)
        if pid then
            local tgtPed = GetPlayerPed(pid)
            if tgtPed and tgtPed ~= 0 then
                if #(srcPos - GetEntityCoords(tgtPed)) <= range then
                    TriggerClientEvent("chat:addMessage", pid, payload)
                end
            end
        end
    end
end

local function sendWebhook(source, message, command, args)
    local webhook = Config.Webhook
    if not webhook or not webhook.enabled then return end
    if type(webhook.handler) == "function" then
        webhook.handler(source, message, command, args)
        return
    end
    if not webhook.url or webhook.url == "" then return end
    local playerName = GetPlayerName(source) or "Unknown"
    local body = json.encode({
        embeds = {{
            title  = "Command Executed",
            description = ("**Player:** %s (ID: %d)\n**Command:** /%s\n**Message:** %s"):format(
                playerName, source, command.command, message
            ),
            color     = 3447003,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }}
    })
    PerformHttpRequest(webhook.url, function() end, "POST", body, {["Content-Type"] = "application/json"})
end

local function validateArgs(command, args, reply)
    if not command.args then return true end
    for i, argDef in ipairs(command.args) do
        local value = args[i]
        if argDef.required ~= false and (not value or value == "") then
            if command.usage then reply(command.usage, "Usage") end
            return false
        end
        if value and argDef.type then
            if argDef.type == "number" then
                if not tonumber(value) then
                    reply(("Argument '%s' must be a number."):format(argDef.name), "Invalid Argument")
                    return false
                end
            elseif argDef.type == "playerId" then
                local pid = tonumber(value)
                if not pid or not GetPlayerName(pid) then
                    reply(("Argument '%s' must be a valid player ID."):format(argDef.name), "Invalid Argument")
                    return false
                end
            elseif argDef.type == "string" then
                if argDef.minLength and #value < argDef.minLength then
                    reply(("Argument '%s' must be at least %d character(s)."):format(argDef.name, argDef.minLength), "Invalid Argument")
                    return false
                end
                if argDef.maxLength and #value > argDef.maxLength then
                    reply(("Argument '%s' must be no more than %d character(s)."):format(argDef.name, argDef.maxLength), "Invalid Argument")
                    return false
                end
            end
        end
    end
    return true
end

local function checkCooldown(source, command, reply)
    local cooldown = command.cooldown
    if cooldown == nil then
        cooldown = Config.Cooldowns and Config.Cooldowns.default or 0
    end
    if cooldown <= 0 then return true end
    local now = os.time()
    cooldownTracker[source] = cooldownTracker[source] or {}
    local expiry = cooldownTracker[source][command.command]
    if expiry and now < expiry then
        local remaining = expiry - now
        reply(("Please wait %d second(s) before using /%s again."):format(remaining, command.command), "Cooldown")
        return false
    end
    cooldownTracker[source][command.command] = now + cooldown
    return true
end

local function commandHandler(command, source, args, raw)
    if not source or source == 0 then
        log("This command can not be executed by the console")
        return false
    end

    local function reply(text, title)
        local messageArgs = {text}
        if title then messageArgs = {title, text} end
        TriggerClientEvent("chat:addMessage", source, {
            color     = command.color or {255, 255, 255},
            multiline = true,
            args      = messageArgs
        })
    end

    local function fail(reason, showNoperm)
        if showNoperm and command.noperm then reply(command.noperm) end
        if Config.Callbacks.onCommandFailed then
            Config.Callbacks.onCommandFailed(source, reason, command, args, raw)
        end
        return false
    end

    if command.prereq then
        if not command.prereq(source, command, args, raw) then
            return fail("prereq", false)
        end
    end

    if command.admin and Config.AdminCheck then
        if not Config.AdminCheck(source) then
            return fail("permission", true)
        end
    end

    if command.reply then
        if command.title then
            reply(command.reply, command.title)
        else
            reply(command.reply)
        end
        return true
    end

    local isAdmin = Config.AdminCheck and Config.AdminCheck(source)
    if not isAdmin and not checkCooldown(source, command, reply) then
        if Config.Callbacks.onCommandFailed then
            Config.Callbacks.onCommandFailed(source, "cooldown", command, args, raw)
        end
        return false
    end

    if not validateArgs(command, args, reply) then
        if Config.Callbacks.onCommandFailed then
            Config.Callbacks.onCommandFailed(source, "invalid_args", command, args, raw)
        end
        return false
    end

    if #args > 0 or command.noargs then
        local visualId   = source
        local argMessage = table.concat(args, " ")

        local function processCommand(visualName)
            local message = formatString(command.format or "", source, visualId, visualName, argMessage)

            if not command.hidden then
                local messageArgs = {message}
                if command.title then
                    messageArgs = {formatString(command.title, source, visualId, visualName, argMessage), message}
                end
                local payload = {
                    color     = command.color or {255, 255, 255},
                    multiline = true,
                    args      = messageArgs
                }
                if command.range and command.range ~= -1 then
                    triggerProximityMessage(source, command.range, payload)
                else
                    TriggerClientEvent("chat:addMessage", -1, payload)
                end
            end

            if command.cb then command.cb(source, message, command, args, raw) end
            if Config.Callbacks.onCommandExecuted then
                Config.Callbacks.onCommandExecuted(source, message, command, args, raw)
            end
            sendWebhook(source, message, command, args)
        end

        if Config.Formatting.useFrameworkName then
            if Config.Framework == 'esx' and ESX then
                local identifier = GetPlayerIdentifiers(source)[1]
                if identifier and MySQL and MySQL.Async and MySQL.Async.fetchAll then
                    MySQL.Async.fetchAll(
                        "SELECT firstname, lastname FROM users WHERE identifier = @identifier",
                        {['@identifier'] = identifier},
                        function(result)
                            local name = GetPlayerName(source) or "Unknown"
                            if result and result[1] then
                                local id = result[1]
                                name = ((id.firstname or "") .. " " .. (id.lastname or "")):match("^%s*(.-)%s*$")
                            end
                            processCommand(name)
                        end
                    )
                    return true
                end
            elseif (Config.Framework == 'qbcore' or Config.Framework == 'qbox') and QBCore then
                local player = QBCore.Functions.GetPlayer(source)
                local name   = GetPlayerName(source) or "Unknown"
                if player and player.PlayerData and player.PlayerData.charinfo then
                    local ci = player.PlayerData.charinfo
                    name = (ci.firstname or "") .. " " .. (ci.lastname or "")
                end
                processCommand(name)
                return true
            end
        end

        processCommand(GetPlayerName(source) or "Unknown")
    else
        if command.usage then reply(command.usage, "Usage") end
        if Config.Callbacks.onCommandFailed then
            Config.Callbacks.onCommandFailed(source, "no_args", command, args, raw)
        end
    end
end

for _, command in next, COMMANDS do
    log(("Registering command /%s from pack %s by %s"):format(command.command, command.pack or "?", command.author or "?"))
    local aceLocked = false
    if command.admin then
        if Config.Framework == 'standalone' then
            aceLocked = true
        end
    end
    if Config.Framework == 'esx' and command.admin then
        TriggerEvent('es:addGroupCommand', command.command, 'admin', function(source, args, user)
            commandHandler(command, source, args, "")
        end, function(source, args, user)
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', (command.noperm and command.noperm or 'Insufficient Permissions.') } })
        end)
    else
        RegisterCommand(command.command, function(source, args, raw)
            commandHandler(command, source, args, raw)
        end, aceLocked)
    end
    if command.help then
        TriggerClientEvent("chat:addSuggestion", -1, "/" .. command.command, command.help, command.args)
    end
end


