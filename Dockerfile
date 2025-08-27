FROM php:7.4-fpm-alpine

# 安装系统依赖
RUN apk add --no-cache \
    nginx \
    mysql-client \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    supervisor

# 安装PHP扩展
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        pdo_mysql \
        mysqli \
        zip \
        bcmath \
        pcntl

# 安装Composer (使用兼容版本)
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# 设置工作目录
WORKDIR /var/www/html

# 复制项目文件
COPY . .

# 安装PHP依赖 (跳过插件以避免兼容性问题)
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-plugins || \
    composer update --no-dev --optimize-autoloader --no-interaction --no-plugins || \
    echo "Composer dependencies already exist"

# 设置权限和创建必要目录
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && mkdir -p /var/www/html/runtime \
    && mkdir -p /var/www/html/runtime/log \
    && mkdir -p /var/www/html/runtime/cache \
    && mkdir -p /var/www/html/runtime/temp \
    && chown -R www-data:www-data /var/www/html/runtime \
    && chmod -R 777 /var/www/html/runtime \
    && chmod -R 777 /var/www/html/public/qr-code \
    && if [ -f /var/www/html/public/qr-code/test.php ]; then chmod 777 /var/www/html/public/qr-code/test.php; fi \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /var/run

# 复制配置文件
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 创建nginx运行目录
RUN mkdir -p /run/nginx

# 暴露端口
EXPOSE 80

# 启动supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
