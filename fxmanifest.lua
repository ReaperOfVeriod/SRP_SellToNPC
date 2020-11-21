fx_version 'adamant'

game 'gta5'

author 'ReaperOfVeriod'
description 'SanctuaryRP selling to NPC script'
version '1.0.0'

version '1.0.3'

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    
    'server/server.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'config.lua'
}
