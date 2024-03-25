fx_version 'cerulean'

games { 'gta5' }

author 'averageee5m'

lua54 'yes'

description 'Clean Hud for Fivem'

ui_page 'ui/index.html'

files {
    'ui/**/**/*.*'
}

client_scripts {
    'client/*.lua',
}

shared_script {
    '@ox_lib/init.lua',
	'@qb-core/shared/locale.lua',
    -- 'config.lua',
}

exports {
    'showNotification'
}

