fx_version 'cerulean'

author 'FTDark'
description 'Rent-A-Car for vRP and QB-Core'
version '1.0.0'

game 'gta5'

ui_page 'html/index.html'

client_script {
    'client.lua'
}

shared_scripts { 
    'cfg.lua',
    '@qb-core/import.lua'
}

server_scripts {
    'server.lua'
}

files {
    'html/*'
}