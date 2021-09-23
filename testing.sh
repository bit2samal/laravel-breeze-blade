#!/bin/bash

# brewbroker-api
# 
EXIT_CODE=0
POSTMAN_COLLECTION_ID='16769215-d2b9b956-db54-437a-8d0e-7b371747442e'
POSTMAN_API_KEY='PMAK-614c65dbcb22480034545af4-c75a821bdda91b30360f2cec789117630d'
POSTMAN_ENV_ID='16769215-a702a373-083c-4943-aaad-e971abcb5ae8'

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
./hooks/commands/phpcs.sh
./hooks/commands/phpmd.sh

./vendor/bin/phpunit;
EXIT_CODE=$?

./hooks/commands/security_checker.sh

if($EXIT_CODE -eq 1)
  then
    exit 1
fi

apache2-foreground
