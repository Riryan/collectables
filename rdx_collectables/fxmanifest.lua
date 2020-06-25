fx_version 'adamant'
games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'RDX Collectables'

author 'Karl Saunders & RiryanCrow'

version '1.0.7'

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    '@redm_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'server/utils.lua',
    'server/main.lua'
}

client_scripts {
    '@redm_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'client/utils.lua',
    'client/main.lua'
}

dependencies {
    'redm_extended',
}