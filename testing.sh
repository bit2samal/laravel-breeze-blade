#!/bin/bash

# brewbroker-api
# 
EXIT_CODE=0

DEPLOY_READY=$(curl -s 'https://api.reviewee.it/repository/elate-api/haveRejectedCommits' | jq -r '.success')

if $DEPLOY_READY;
  then  echo "Commit check: OK \n"
else
    echo "Commit check: Have Rejected commits \n"
    exit 1
fi

# php artisan migrate --force
echo "Running Postman test...\n"
newman run https://api.getpostman.com/collections/${POSTMAN_COLLECTION_ID}?apikey=${POSTMAN_API_KEY} -e https://api.getpostman.com/environments/${POSTMAN_ENV_ID}?apikey=${POSTMAN_API_KEY} 
EXIT_CODE=$?
if [ $EXIT_CODE -eq 1 ];
  then
    exit 1
fi

./vendor/bin/phpunit;
EXIT_CODE=$?
if [ $EXIT_CODE -eq 1 ];
  then
    exit 1
fi

./hooks/commands/phpcs.sh
./hooks/commands/phpmd.sh
./hooks/commands/security_checker.sh

apache2-foreground
