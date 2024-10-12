#!/bin/bash


# Nginx ve PHP-FPM'i başlatıyoruz
service php7.4-fpm start
service nginx start

# Konteynerin açık kalması için sonsuz bir döngü başlatıyoruz
tail -f /var/log/nginx/access.log

