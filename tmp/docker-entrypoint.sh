#!/bin/bash

set -e

# Restart ssh service
sudo service ssh restart >/dev/null 2>&1

# Set the timezone with TZ
if [ -n "$TZ" ]; then
	echo "Setting timezone to $TZ"
	rm -f /etc/localtime
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >/etc/timezone
	if [ $? -eq 0 ]; then
		echo "Timezone set successfully"
	else
		echo "Error setting timezone"
	fi
fi

# Append ENV value to the end of /etc/profile
sudo echo "export $(cat /proc/1/environ | tr '\0' '\n' | xargs)" >>/etc/profile
# for item in $(cat /proc/1/environ | tr '\0' '\n'); do
# 	export $item
# done

echo "Welcome to the container!"

exec "$@"
