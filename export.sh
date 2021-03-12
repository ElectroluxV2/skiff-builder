#!/bin/bash
pushd /home/ubuntu/skiff-builder || return 1

. ./variables.sh

if [ -d 'build' ]; then

ls

  pushd build || (popd && exit 2)
  git pull origin main

else

  pushd build || (popd && exit 3)
  git clone $repository 'build'

fi

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH='/snap/bin/chromium'

npm i
npm run prod

lftp -u $user,$password $server -e "set ftp:ssl-allow no; mirror -R $local $remote; exit"

popd || exit 4
popd || exit 5

exit 0
