FROM iget/default-www

# Install packages
RUN apt-get clean
RUN apt -y update && apt install -y \
    php7.2-imagick \
    # XVFB dependencies to allow running headless NightmareJS
    libgtk2.0-0 \
    libgconf-2-4 \
    libasound2 \
    libxtst6 \
    libxss1 \
    libnss3 \
    xvfb \
    # Imagick dependency allow thumbnail and image processing
    php-imagick \
    # Rsyslog allow sharing the log with the ELK
    rsyslog \
    nano \
    && rm -rf /var/lib/apt/lists/* && echo 'Packages installed and lists cleaned'
    
RUN locale-gen pt_BR.UTF-8 && locale-gen it_IT.UTF-8 && locale-gen es_ES.UTF-8

# Add Supervisor configuration files
COPY conf/supervisor/* /etc/supervisor/conf.d/
    
# The hirak/prestissimo package speed-up the
# composer install step significatively.
RUN composer global require hirak/prestissimo

# Add Laravel Schedule to crontab
RUN echo "* * * * * php /var/www/artisan schedule:run >> /dev/null 2>&1" | crontab -u www-data -