---@type table
MySQL = MySQL or {}

local function commandHandler(command, source, args, raw)
    if not source or source == 0 then
        log("This command can not be executed by the console")
        return false
    end
    local function reply(text, title)
        local messageArgs = {text}
        if title then messageArgs = {title, text} end
        TriggerClientEvent("chat:addMessage", source, {
            color = command.color or {255, 255, 255},
            multiline = true,
            args = messageArgs
        })
    end
    local function deny()
        if command.noperm then reply(command.noperm) end
    end
    if command.prereq then
        if not command.prereq(source, command, args, raw) then
            deny()
            return false
        end
    end
    if command.admin then
        if Config.AdminCheck then
            if not Config.AdminCheck(source) then
                deny()
                return false
            end
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
    if #args > 0 or command.noargs then
        local visualName = GetPlayerName(source)
        local visualId = source
        if Config.Formatting.useFrameworkName then
            if Config.Framework == 'esx' and ESX then
                local identifier = GetPlayerIdentifiers(source)[1]
                if identifier and MySQL and MySQL.Sync and MySQL.Sync.fetchAll then
                    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
                    if result[1] ~= nil then
                        local identity = result[1]
                        visualName = (identity['firstname'] or "") .. " " .. (identity['lastname'] or "")
                    end
                end
            elseif (Config.Framework == 'qbcore' or Config.Framework == 'qbox') and QBCore then
                local player = QBCore.Functions.GetPlayer(source)
                if player and player.PlayerData and player.PlayerData.charinfo then
                    local ci = player.PlayerData.charinfo
                    visualName = (ci.firstname or "") .. " " .. (ci.lastname or "")
                end
            end
        end
        local message = command.format or ""
        message = message:gsub("#username#", Config.Formatting.showPlayerId and (GetPlayerName(source) .. " (" .. visualId .. ")") or GetPlayerName(source))
        message = message:gsub("#char#", visualName)
        message = message:gsub("#name#", Config.Formatting.showPlayerId and (visualName .. " (" .. visualId .. ")") or visualName)
        message = message:gsub("#id#", tostring(visualId))
        message = message:gsub("#message#", table.concat(args, " "))
        if not command.hidden then
            local messageArgs = {message}
            if command.title then
                local title = command.title
                title = title:gsub("#username#", Config.Formatting.showPlayerId and (GetPlayerName(source) .. " (" .. visualId .. ")") or GetPlayerName(source))
                title = title:gsub("#char#", visualName)
                title = title:gsub("#name#", Config.Formatting.showPlayerId and (visualName .. " (" .. visualId .. ")") or visualName)
                title = title:gsub("#id#", tostring(visualId))
                title = title:gsub("#message#", table.concat(args, " "))
                messageArgs = {title, message}
            end
            if command.range and command.range ~= -1 then
                TriggerClientEvent("pxc:proximity", -1, source, command.range, {
                    color = command.color or {255, 255, 255},
                    multiline = true,
                    args = messageArgs
                })
            else
                TriggerClientEvent("chat:addMessage", -1, {
                    color = command.color or {255, 255, 255},
                    multiline = true,
                    args = messageArgs
                })
            end
        end
        if command.cb then command.cb(source, message, command, args, raw) end
        if Config.Callbacks.onCommandExecuted then Config.Callbacks.onCommandExecuted(source, message, command, args, raw) end
    else
        if command.usage then reply(command.usage, "Usage") end
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

if not Config.FXServerCheck then
    log("Unsupported FXServer version")
    log("Required: FXServer 1226 or newer")
    log("Current: " .. GetConvar("version", ""))
end
