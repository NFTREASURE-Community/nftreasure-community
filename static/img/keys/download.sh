#!/usr/bin/env bash

# Download all the keys.

for KEY in $(seq -f "%03g" 001 150); do

	echo "Downloading Key $KEY"

	curl \
		--header "Origin: https://game.nftreasure.com" \
		--location \
		--verbose https://d1f8cbnxme5omx.cloudfront.net/images/keys/thumb-Key%2$KEY.jpg \
		--output key-$KEY.jpg

done
