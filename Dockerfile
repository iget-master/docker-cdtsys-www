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
    
# The hirak/prestissimo package speed-up the
# composer install step significatively.
RUN composer global require hirak/prestissimo
