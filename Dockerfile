# OFFICIAL REPOSITORY
FROM php:7.1-fpm

ENV DEBIAN_FRONTEND noninteractive

# INSTALL PACKAGES
RUN apt-get update -qq && apt-get install -y \
    locales -qq \
    && locale-gen en_AU \
    && locale-gen en_AU.UTF-8 \
    && dpkg-reconfigure locales \
    && locale-gen C.UTF-8 \
    && dpkg-reconfigure locales \
    && apt-get update && apt-get install -y \
      software-properties-common \
      python-software-properties \
      build-essential \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update && apt-get install -y  \
      supervisor \
      nginx \
      wget \
      curl \
      zip \
      unzip \
      apache2

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# Install Composer
RUN wget -O /tmp/composer.phar https://getcomposer.org/composer.phar \
    && cp /tmp/composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && rm /etc/apache2/sites-enabled/000-default.conf

# Apache config
COPY apache2.conf /etc/apache2/apache2.conf
COPY site-config.conf /etc/apache2/sites-enabled/000-default.conf

# Expose port 80 for apache
EXPOSE 80

# Testing
COPY ./start.sh /start.sh
COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/start.sh"]
