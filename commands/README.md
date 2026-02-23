# Example Command Pack

This folder holds third-party and user-created command packs. Each pack is a Lua file that calls `CommandPack()` to register commands.

Example structure of a command pack file:

```lua
CommandPack("MyPack", "AuthorName", {
    {
        command = "mycommand",
        format = "#name# used /mycommand",
        help = "Description of the command",
        args = { {name = "arg1", help = "First argument"} },
    },
}, { color = {0, 255, 0} })
```