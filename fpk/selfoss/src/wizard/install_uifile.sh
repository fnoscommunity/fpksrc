#!/bin/bash

quote_json ()
{
	sed -e 's|\\|\\\\|g' -e 's|\"|\\\"|g'
}

page_append ()
{
	if [ -z "$1" ]; then
		echo "$2"
	elif [ -z "$2" ]; then
		echo "$1"
	else
		echo "$1,$2"
	fi
}

# Check for multiple PHP profiles
check_php_profiles ()
{
	PHP_CFG_PATH="/usr/syno/etc/packages/WebStation/PHPSettings.json"
	return 1  # false
}

PAGE_PHP_PROFILES=$(/bin/cat<<EOF
{
	"step_title": "Multiple PHP profiles",
	"items": [{
		"desc": "Attention: Multiple PHP profiles detected; the package webpage will not display until a DSM restart is performed to load new configurations."
	}]
}
EOF
)

main () {
	local install_page=""
	if check_php_profiles; then
		install_page=$(page_append "$install_page" "$PAGE_PHP_PROFILES")
	fi
	echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
