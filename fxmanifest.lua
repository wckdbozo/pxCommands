fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'pxCommands'
author 'CodeMeAPixel'
contact 'hey@codemeapixel.dev'
description 'A modular and extendable chat/command system'
license 'GPL-3.0-or-later'
repository 'https://github.com/CodeMeAPixel/pxCommands'
version '0.2.0'

shared_scripts {
    'system/config.lua'
}

client_scripts {
    'system/client/**',
    'modules/cl_*.lua'
}

server_scripts {
    'system/server/pre.lua',
    'commands/*.lua',
    'system/server/commands.lua',
    'system/versioncheck.lua'
}


