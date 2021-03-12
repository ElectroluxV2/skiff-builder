#!/usr/bin/env bash
pushd /home/ubuntu/skiff-builder || return 1

. ./variables.sh

if [ -d 'build' ]; then

  git pull origin main

else

  git clone $repository 'build'

fi

pushd 'build' || popd && exit 2

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH='/snap/bin/chromium'

npm i

npm run prod

lftp -u $user,$password $server -e "set ftp:ssl-allow no; mirror -R $local $remote; exit"

popd || exit 3

exit 0
