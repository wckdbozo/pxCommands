CommandPack("Example", "pxCommands", {
    {
        command = "test",
        format = "#name# used /test",
        help = "Test command with no arguments required",
        color = {0, 255, 0},
    },
    {
        command = "greet",
        format = "#name# greeted: #message#",
        help = "Greet someone",
        color = {100, 200, 255},
        args = { {name = "name", help = "Who to greet"} },
    },
    {
        command = "admin_only",
        format = "#name# used admin command",
        help = "Admin-only command (requires ACL)",
        admin = true,
        noperm = "You don't have permission to use this command.",
        color = {255, 0, 0},
    },
}, {
    color = {200, 200, 200},
})