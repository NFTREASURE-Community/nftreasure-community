#!/usr/bin/env bash

clear

set -euo pipefail

# Create the initial YAML config.
cat <<- EOF > keys.yaml
	---
	keys:
EOF

function message() {
	echo -e "\e[1;32m$1\e[0m"
}

function warning() {
	echo -e "\e[1;33m$1\e[0m"
}

function error () {
	echo -e "\e[1;31m$1\e[0m"
}

function download_key() {
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

		if eval "$( "${CURL_COMMAND[@]}" )";
		then
			return 0
		else
			return 1
		fi

}

# Download all the keys and update the YAML.
for KEY in $(seq -f "%03g" 001 150); do

	ADD_KEY=FALSE
	
	# Does the key file already exist?
	if [[ -f "key-${KEY}.jpg" ]];
	then

		# Is the file size greater than 1KB?
		if [[ $(stat -c %s "key-${KEY}.jpg") -gt 1024 ]];
		then

			ADD_KEY="TRUE"
			message "Key already downloaded, skipping download of key $KEY"

		else

			warning "Key $KEY exists but is empty, re-downloading"
			download_key $KEY || {
				error "Failed to download key $KEY!"
				continue
			}

		fi

	fi

	if [[ "${ADD_KEY}" == "TRUE" ]];
	then

		message "Adding key $KEY to config"

		cat <<- EOF >> keys.yaml
		  - name: "Key $KEY"
		    image: "/img/keys/key-$KEY.jpg"
		    categories: ["Keys"]
		    content: "NFKey level $KEY"
		
		EOF

	fi

done

message "Finished!"
exit 0
