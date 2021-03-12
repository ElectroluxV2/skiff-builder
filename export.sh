#!/bin/bash
pushd $cwd || return 1

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
export PUPPETEER_EXECUTABLE_PATH=$chromium
export PATH=$path:PATH

npm i
npm --scripts-prepend-node-path=true run prod

lftp -u $user,$password $server -e "set ftp:ssl-allow no; mirror -R $local $remote; exit"

popd || exit 4
popd || exit 5

exit 0
