FROM jdecode/laravel-breeze-php8-pg-node:4

RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

RUN a2enmod rewrite

COPY . .

RUN composer install

RUN chmod -R 777 ./storage/
RUN chmod -R 777 ./bootstrap/
RUN chmod 777 ./setup.sh

ENTRYPOINT [ "/var/www/html/setup.sh" ]
