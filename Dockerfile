FROM b2k8786/php-node

RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

RUN a2enmod rewrite

COPY . .

RUN composer install

RUN chmod -R 777 /var/www/html/storage/
RUN chmod -R 777 /var/www/html/bootstrap/
RUN chmod 777 /var/www/html/setup.sh

ENTRYPOINT [ "/var/www/html/setup.sh" ]
