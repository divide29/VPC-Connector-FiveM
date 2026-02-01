fx_version 'cerulean'
game 'gta5'

name 'VPC Connector'
author 'Lumevo Interactive'
description 'A resource to integrate CopNet and other networks from VPC into your FiveM server.'
version '4.0.0'

client_scripts {
  'shared/helper.lua',
  'client/target.lua',
  'client/framework.lua',
  'client/keybinds.lua',
  'client/livemap.lua',
  'client/client.lua',
}



server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'shared/helper.lua',
  'server/framework.lua',
  'server/commands.lua',
  'server/livemap.lua',
  'server/server.lua',
  'server/database.lua',
}

files {
  "html/index.html",
  "html/script.js",
  "html/style.css",
  "html/tablet.png",
  "html/tablet-s.png",
  "html/tablet-us.png"
}

lua54 'yes'
ui_page "html/index.html"
use_experimental_fxv2_oal 'yes'
