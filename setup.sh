#!/bin/bash

set +o xtrace
set -o errexit

if [ -z ${LBRY_DESKTOP_BUILD+x} ]; then
    echo "Please set LBRY_DESKTOP_BUILD to the location of lbry-desktop web bundle."
    exit 1
fi

docker-compose up --no-start daemon db app
docker-compose start daemon db

docker-compose run app pipenv run lbryweb/manage.py reset_db --noinput
docker-compose run app pipenv run lbryweb/manage.py migrate

echo "Waiting 30 seconds for wallet to start..."
sleep 30

docker-compose start app
echo "All done, you can navigate to http://localhost:8000/ now."
