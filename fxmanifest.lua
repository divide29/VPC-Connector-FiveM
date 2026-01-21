fx_version 'cerulean'
game 'gta5'

name 'VPC Connector'
author 'Lumevo Interactive'
description 'A resource to integrate CopNet and other networks from VPC into your FiveM server.'
version '4.0.0'

client_scripts {
  'shared/config.lua',
  'shared/helper.lua',
  'shared/target.lua',
  'client/client.lua',
  --'client/api_client.lua',
}



server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'shared/config.lua',
  'shared/helper.lua',
  --'shared/api_config.lua',
  --'server/api_server.lua',
  'server/server.lua',
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
