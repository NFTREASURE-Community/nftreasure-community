#!/usr/bin/env bash

clear

set -euo pipefail

##################################################
# Variables
##################################################

LOG_FILE="keys.log"
CONFIG_FILE="keys.yaml"

##################################################
# Functions
##################################################

function log {
	echo "$1" >>"$LOG_FILE"
}

function message() {
	echo -e "\e[1;32m$1\e[0m"
}

function warning() {
	echo -e "\e[1;33m$1\e[0m"
	log "$1"
}

function error() {
	echo -e "\e[1;31m$1\e[0m"
	log "$1"
}

function key_check() {
	KEY=$1

	# Does the key file exist?
	if [[ -f "key-${KEY}.jpg" ]]; then

		# Is the file size greater than 1KB?
		if [[ $(stat -c %s "key-${KEY}.jpg") -gt 1024 ]]; then
			return 0
		else
			return 1
		fi

	else

		return 1

	fi

}

function key_download() {
	KEY=$1

	CURL_COMMAND=(
		"curl"
		"--header"
		"Origin: https://game.nftreasure.com"
		"--location"
		"https://assets.nftreasure.com/images/keys/thumb-Key%2$KEY.jpg"
		"--output"
		"key-$KEY.jpg"
	)

	if eval "$("${CURL_COMMAND[@]}")"; then
		return 0
	else
		return 1
	fi

}

function key_config() {
	KEY=$1

	cat <<-EOF >>"$CONFIG_FILE"
		  - name: "Key $KEY"
		    image: "/img/keys/key-$KEY.jpg"
		    categories: ["Keys"]
		    content: "NFKey level $KEY"

	EOF

}

##################################################
# Main
##################################################

# Remove the log
rm -f "$LOG_FILE" || true

# Create the initial YAML config.
cat <<-EOF >"$CONFIG_FILE"
	---
	keys:
EOF

# Download all the keys and update the YAML.
for KEY in $(seq -f "%03g" 001 150); do

	ADD_KEY=FALSE

	message "Checking key $KEY"
	if key_check "$KEY"; then

		# Nothing to do, key is already downloaded.
		ADD_KEY=TRUE
		message "Key $KEY already exists"

	else

		# Try and download the key.
		key_download "$KEY" || {
			warning "Failed to download key $KEY!"
			rm -f "key-$KEY.jpg" || true
			continue
		}

		# Check the key again to ensure it was downloaded ok.
		if key_check "$KEY"; then
			ADD_KEY=TRUE
		else
			error "Failed to download key $KEY!"
			rm -f "key-$KEY.jpg" || true
			continue
		fi

	fi

	if [[ ${ADD_KEY} == "TRUE" ]]; then

		key_config "$KEY" || {
			error "Failed to add key $KEY to config!"
			continue
		}

	fi

done

message "Finished!"
exit 0
