#!/bin/bash

# brewbroker-api

DEPLOY_READY=$(curl -s 'https://api.reviewee.it/repository/brewbroker-api/haveRejectedCommits' | jq -r '.success')

if $DEPLOY_READY;
  then  echo "Commit check: OK \n"
else
    echo "Commit check: Have Rejected commits"
    exit 1
fi

php artisan migrate --force

newman run https://api.getpostman.com/collections/${POSTMAN_COLLECTION_ID}?apikey=${POSTMAN_API_KEY} -e https://api.getpostman.com/environments/${POSTMAN_ENV_ID}?apikey=${POSTMAN_API_KEY}

./hooks/commands/phpcs.sh
./hooks/commands/phpmd.sh
./hooks/commands/phpunit.sh
./hooks/commands/security_checker.sh

apache2-foreground

