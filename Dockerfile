# Ubuntu imajını kullanarak başlıyoruz
FROM ubuntu:20.04

# sistemi güncelliyoruz ve nginx ve php için gerekli paketleri yüklüyoruz
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    # DEBIAN_FRONTEND=noninteractive kurulum esnasında kullanıcıdan bilgi girilmesini istememesi için gereklidir
    nginx \
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
    # apt-get clean Bu komut, APT'nin önbelleğinde bulunan ve artık ihtiyaç duyulmayan paket indirme dosyalarını silmemize yarar
    # rm -rf /var/lib/apt/lists/* Bu komut, APT'nin paket bilgilerini ve liste dosyalarını içeren dizini temizler. 
    # apt-get clean && rm -rf /var/lib/apt/lists/* komut sayesinde disk temizleme yaparak gereksiz data bırakmıyoruz

# Nginx için yapılandırma dosyasını ekliyoruz
COPY nginx.conf /etc/nginx/sites-available/wordpress
COPY startup.sh /startup.sh
#sistemdeki nginx.conf dosyasını containerdeki /etc/nginx/sites-available/wordpress dizinine kopyalıyoruz ve ismini wordpress olarak değiştiriyoruz
RUN ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/ && \
# Bu komut, Nginx için bir sembolik bağlantı (soft link) oluşturur, Bu sayeda wordpress dosyasını entkin duruma alıyoruz
    echo "cgi.fix_pathinfo=0;" >> /etc/php/7.4/fpm/php.ini && \
    # PHP-FPM, Nginx tarafından sağlanan URI'yi daha güvenli bir şekilde işlemesi için cgi.fix_pathinfo 0 değerine alıyoruz ve bu kodu >> /etc/php/7.4/fpm/php.ini bu komut sayesinde php.ini dosyasının en alt satırına ekliyoruz
# WordPress dosyalarını indirip kuruyoruz
    wget https://wordpress.org/latest.tar.gz -P /tmp && \
    tar -xvzf /tmp/latest.tar.gz -C /var/www/ && \ && \
# WordPress dizin ve dosya izinlerini ve sahipliğini ayarlıyoruz
    chown -R www-data:www-data /var/www/wordpress && \ && \
    find /var/www/wordpress -type d -exec chmod 755 {} \; && \
    find /var/www/wordpress -type f -exec chmod 644 {} \; && \
# Başlangıç komut dosyasını çalıştırılabilir hale getiriyoruz
    chmod +x /startup.sh
# Gerekli portları açıyoruz
EXPOSE 80
# Başlangıç komut dosyasını çalıştırıyoruz
CMD ["/startup.sh"]

