fx_version 'bodacious'
game 'gta5'

description 'ES Extended'
lua54 'yes'
version '1.2.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/handlarz.html',
    'html/atleta.html',
    'html/kulturysta.html',
    'html/lowcaokazji.html',
    'html/makler.html',
    'html/ogrodnik.html',
    'html/przedsiebiorca.html',
    'html/zlotaraczka.html',
    'html/*.png',
    'html/*.html'
}

client_scripts {
	'config.lua',
	'client.lua'
}

shared_script '@es_extended/imports.lua'

server_scripts{
    'server.lua',
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua'
}

dependencies {
	'mysql-async',
    'es_extended'
}
