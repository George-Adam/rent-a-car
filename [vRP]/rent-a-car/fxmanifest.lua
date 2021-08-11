fx_version 'cerulean'

author 'FTDark'
description 'Rent-A-Car for vRP'
version '1.0.0'

game 'gta5'

ui_page 'html/index.html'

client_script {
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    'client.lua'
}

shared_scripts { 
    'cfg.lua'
}

server_scripts {
    "@vrp/lib/utils.lua",
    'server.lua'
}

files {
    'html/*'
}