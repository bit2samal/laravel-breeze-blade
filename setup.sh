#!/bin/bash
apache2-foreground

php artisan migrate --force
