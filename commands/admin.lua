CommandPack("Admin", "CodeMeAPixel", {
    {
        command  = "announce",
        format   = "[ANNOUNCEMENT] #message#",
        title    = "Server Announcement",
        help     = "Broadcast an announcement to all players",
        usage    = "/announce [message]",
        color    = {255, 165, 0},
        admin    = true,
        noperm   = "You don't have permission to use this command.",
        cooldown = 10,
        args     = {{name = "message", help = "Announcement text", type = "string", minLength = 1}},
    },
    {
        command = "staffchat",
        format  = "[STAFF] #name#: #message#",
        help    = "Send a message visible only to online staff",
        usage   = "/staffchat [message]",
        color   = {200, 100, 255},
        admin   = true,
        hidden  = true,
        noperm  = "You don't have permission to use this command.",
        args    = {{name = "message", help = "Your staff message", type = "string", minLength = 1}},
        cb      = function(source, message, command, args, raw)
            if not Config.AdminCheck then return end
            for _, playerId in ipairs(GetPlayers()) do
                local pid = tonumber(playerId)
                if pid and Config.AdminCheck(pid) then
                    TriggerClientEvent("chat:addMessage", pid, {
                        color     = command.color,
                        multiline = true,
                        args      = {message},
                    })
                end
            end
        end,
    },
    {
        command = "kick",
        format  = "",
        help    = "Kick a player from the server",
        usage   = "/kick [id] [reason]",
        color   = {255, 80, 80},
        admin   = true,
        hidden  = true,
        noperm  = "You don't have permission to use this command.",
        args    = {
            {name = "id",     help = "Player server ID",  type = "playerId"},
            {name = "reason", help = "Reason for kick",   required = false},
        },
        cb = function(source, message, command, args, raw)
            local targetId = tonumber(args[1])
            local reason   = #args > 1 and table.concat(args, " ", 2) or "Kicked by staff"
            DropPlayer(tostring(targetId), reason)
            TriggerClientEvent("chat:addMessage", source, {
                color     = command.color,
                multiline = true,
                args      = {("Kicked player %d: %s"):format(targetId, reason)},
            })
        end,
    },
    {
        command = "warn",
        format  = "",
        help    = "Send a warning notification to a player",
        usage   = "/warn [id] [reason]",
        color   = {255, 200, 0},
        admin   = true,
        hidden  = true,
        noperm  = "You don't have permission to use this command.",
        args    = {
            {name = "id",     help = "Player server ID", type = "playerId"},
            {name = "reason", help = "Warning reason",   type = "string", minLength = 1},
        },
        cb = function(source, message, command, args, raw)
            local targetId = tonumber(args[1])
            if not targetId then return end
            local reason   = #args > 1 and table.concat(args, " ", 2) or "No reason given"
            TriggerClientEvent("pxc:notify", targetId, "Warning: " .. reason, "warning")
            TriggerClientEvent("chat:addMessage", source, {
                color     = command.color,
                multiline = true,
                args      = {("Warned player %d: %s"):format(targetId, reason)},
            })
        end,
    },
})
