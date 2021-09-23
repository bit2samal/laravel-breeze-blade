#!/bin/bash

# brewbroker-api
php artisan migrate --force

DEPLOY_READY=$(curl -s 'https://api.reviewee.it/repository/brewbroker-api/haveRejectedCommits' | jq -r '.success')

if $DEPLOY_READY;
  then  echo "\e[32mCommit check: OK \n\e[0m"
else
    echo "\e[31mCommit check: Have Rejected commits \e[0m"
    exit 1
fi

newman run https://api.getpostman.com/collections/${POSTMAN_COLLECTION_ID}?apikey=${POSTMAN_API_KEY} -e https://api.getpostman.com/environments/${POSTMAN_ENV_ID}?apikey=${POSTMAN_API_KEY}

./hooks/commands/phpcs.sh
./hooks/commands/phpmd.sh
./hooks/commands/phpunit.sh
./hooks/commands/security_checker.sh

apache2-foreground
