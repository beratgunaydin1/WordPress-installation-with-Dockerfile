# Temel Ubuntu imajını kullanarak başlıyoruz
FROM ubuntu:20.04

# Gerekli paketleri yüklüyoruz
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nginx \
    mysql-server \
    php7.4-fpm \
    php-mysql \
    php-cli \
    php-curl \
    php-xml \
    php-mbstring \
    php-zip \
    php-gd \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Nginx için yapılandırma dosyasını ekliyoruz
COPY nginx.conf /etc/nginx/sites-available/wordpress
RUN ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
RUN echo "cgi.fix_pathinfo=0;" >> /etc/php/7.4/fpm/php.ini


# WordPress dosyalarını indirip kuruyoruz
RUN wget https://wordpress.org/latest.tar.gz -P /tmp && \
    tar -xvzf /tmp/latest.tar.gz -C /var/www/ && \
    chown -R www-data:www-data /var/www/wordpress
# WordPress dizin ve dosya izinlerini ayarlıyoruz
RUN find /var/www/wordpress -type d -exec chmod 755 {} \; && \
    find /var/www/wordpress -type f -exec chmod 644 {} \;

# Başlangıç komut dosyasını kopyalıyoruz ve çalıştırılabilir hale getiriyoruz
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Gerekli portları açıyoruz
EXPOSE 80

# Başlangıç komut dosyasını çalıştırıyoruz
CMD ["/startup.sh"]

