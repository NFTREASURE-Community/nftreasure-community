#!/usr/bin/env bash

clear
set -euo pipefail

##################################################
# Variables
##################################################

LOG_FILE="keys.log"
CONFIG_FILE="keys.yaml"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

##################################################
# Functions
##################################################

function log_file() {
	echo "$1" >>"$LOG_FILE"
}

function log_header() {
	MESSAGE=$1
	echo -e "----------------------------------------"
	echo -e "${YELLOW}$MESSAGE${NC}"
	echo -e "----------------------------------------"
}

function log_info() {
	MESSAGE=$1
	echo -e "${GREEN}$MESSAGE${NC}"
	log_file "$MESSAGE"
}

function log_warning() {
	MESSAGE=$1
	echo -e "${YELLOW}$MESSAGE${NC}"
	log_file "$MESSAGE"
}

function log_error() {
	MESSAGE=$1
	echo -e "${RED}$MESSAGE${NC}"
	log_file "$MESSAGE"
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
		"https://assets.nftreasure.com/images/keys/thumb-Key%20$KEY.jpg"
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

log_header "Processing all keys..."

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

	log_info "Checking key $KEY"
	if key_check "$KEY"; then

		# Nothing to do, key is already downloaded.
		ADD_KEY=TRUE
		log_info "\tKey $KEY already exists"

	else

		# Try and download the key.
		key_download "$KEY" || {
			log_warning "\tFailed to download key $KEY!"
			rm -f "key-$KEY.jpg" || true
			continue
		}
		log_info "\tDownloaded key $KEY"

		# Check the key again to ensure it was downloaded ok.
		if key_check "$KEY"; then
			ADD_KEY=TRUE
		else
			log_error "\tFailed to download key $KEY!"
			rm -f "key-$KEY.jpg" || true
			continue
		fi

	fi

	if [[ ${ADD_KEY} == "TRUE" ]]; then

		key_config "$KEY" || {
			log_error "\tFailed to add key $KEY to config!"
			continue
		}

	fi

done

log_header "Finished processing all keys!"
exit 0
