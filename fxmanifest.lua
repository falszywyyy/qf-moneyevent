fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'QF DevTeam'

shared_scripts {'@es_extended/imports.lua', 'config.lua'}

client_scripts {
    "client.lua",
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}