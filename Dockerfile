FROM iget/default-www:alpine

# Add Bash since Alpine is bundled just with SH
RUN apk add --no-cache ca-certificates wget \
    php7-imagick \
    chromium \
    xvfb \
    rsyslog && echo 'Packages installed and lists cleaned'

# Install language pack
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk && \
    apk add glibc-bin-2.25-r0.apk glibc-i18n-2.25-r0.apk glibc-2.25-r0.apk && \
    rm glibc-bin-2.25-r0.apk glibc-i18n-2.25-r0.apk glibc-2.25-r0.apk

# Iterate through all locale and install it
# Note that locale -a is not available in alpine linux, use `/usr/glibc-compat/bin/locale -a` instead
COPY ./locale.list locale.list
RUN cat locale.list | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8  && \
    rm locale.list

# Add Supervisor configuration files
COPY conf/supervisor/* /etc/supervisor.d/
    
# The hirak/prestissimo package speed-up the
# composer install step significatively.
RUN composer global require hirak/prestissimo

# Add Laravel Schedule to crontab
RUN echo "* * * * * php /var/www/artisan schedule:run >> /dev/null 2>&1" | crontab -u www-data -