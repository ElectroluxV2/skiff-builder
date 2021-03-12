#!/usr/bin/env bash

. ./variables.sh

if [ -d 'build' ]; then

  git pull origin main

else

  git clone $repository 'build'

fi

cd 'build' || exit 1

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH='/snap/bin/chromium'

npm i

npm run prod

lftp -u $user,$password $server -e "set ftp:ssl-allow no; mirror -R $local $remote; exit"

exit 0
