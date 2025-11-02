fx_version 'bodacious'
games { 'gta5' }

author 'jaramiyo'
description 'Carry Other People / jaraservices.com'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
}

client_script "cl_carry.lua"

server_script "sv_carry.lua"
