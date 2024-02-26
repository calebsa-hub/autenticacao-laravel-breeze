# Use uma imagem base com PHP e Apache
FROM php:8.2-apache

# Atualize e instale dependências
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        unzip \
        git \
        default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Instale e ative as extensões do PHP necessárias
RUN docker-php-ext-install zip pdo_mysql

# Instale o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copie o código-fonte do Laravel para o contêiner
COPY . /var/www/html

# Configure as permissões
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Exponha a porta 80
EXPOSE 80

# Comando de inicialização
CMD ["apache2-foreground"]
