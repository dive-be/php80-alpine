FROM php:8.0-alpine

# Install PHP modules and clean up
RUN apk add --no-cache $PHPIZE_DEPS imagemagick-dev; \
    # ==============
    # Xdebug
    # ==============
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    # ==============
    # Redis
    # ==============
    pecl install redis; \
    docker-php-ext-enable 'redis.so'; \
    # ==============
    # Remove phpize dependencies
    # ==============
    apk del $PHPIZE_DEPS; \
    echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    # ==============
    # ImageMagick
    # Workaround: https://github.com/Imagick/imagick/issues/331#issuecomment-779190777
    # ==============
    mkdir -p /usr/src/php/ext/imagick; \
    curl -fsSL https://github.com/Imagick/imagick/archive/06116aa24b76edaf6b1693198f79e6c295eda8a9.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1; \
    docker-php-ext-install imagick; \
    # ==============
    # Removing the /usr/src folder saves ~152 MB
    # ==============
    rm -rf /usr/src; \
    rm -rf /tmp/pear;

# Install other dependencies
RUN apk add --no-cache git curl sqlite nodejs npm ncdu; \
    # Note: For yarn 2.0 we should use "yarn set version berry"
    # see: https://yarnpkg.com/getting-started/install
    npm install --global yarn;