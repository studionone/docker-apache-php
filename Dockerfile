# Dockerfile for Nginx + HHVM
FROM ubuntu:14.04.1
MAINTAINER josh@jgirvin.com

# Install nginx and deps for HHVM
RUN apt-get update && apt-get install -y apache2 wget php5 php5-cli php5-readline php5-mysql php5-sqlite php5-imagick php5-xdebug php5-curl php5-mcrypt

# Install Composer
RUN wget -O /tmp/composer.phar https://getcomposer.org/composer.phar && cp /tmp/composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Apache config
ADD apache2.conf /etc/apache2/apache2.conf
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD site-config.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod php5
RUN a2enmod rewrite

# Set up Supervisord
RUN apt-get install supervisor -y

# Expose port 80 for apache
EXPOSE 80

# Testing
ADD ./start.sh /start.sh
ADD supervisord.conf /etc/supervisord.conf

RUN sed -i 's/; max_input_vars = 1000/max_input_vars = 5000/g' /etc/php5/apache2/php.ini

RUN service apache2 stop && service supervisor stop

ENTRYPOINT ["/start.sh"]
