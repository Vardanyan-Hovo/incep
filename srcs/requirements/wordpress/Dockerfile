FROM alpine:3.16

#setting up PHP-FPM, downloading and unpacking WordPress,
# running the script to create wp-config.php and
# setting the command to run PHP-FPM.

# Define PHP_VERSION and database-related arguments
ARG PHP_VERSION=8
ARG DB_NAME
ARG DB_USER
ARG DB_PASS

# Update packages and install necessary dependencies
RUN apk update && apk upgrade && apk add --no-cache \
    php8 php8-fpm php8-mysqli php8-json \
    php8-curl php8-dom php8-exif php8-fileinfo \
    php8-mbstring php8-openssl php8-xml php8-zip \
    wget \
    unzip && \
    #we modify the www.conf file to configure PHP-FPM to listen on port 9000,
    # change the owner and group of the PHP-FPM process to
    # "none" all this for usually used for security reasons.
    # Configure PHP-FPM
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
      /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php8/php-fpm.d/www.conf && \
    # Clean up
    rm -f /var/cache/apk/*

#1 The sed command searches for the text listen = 127.0.0.1:9000 in 
#  the www.conf file and replaces it with listen = 9000.


# Set working directory to /var/www
WORKDIR /var/www

# Download and extract WordPress
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    cp -rf wordpress/* . && \
    rm -rf wordpress latest.zip

# Copy wp-config-create.sh script and run it to generate wp-config.php
COPY ./requirements/wordpress/conf/wp-config-create.sh .
RUN sh wp-config-create.sh && rm wp-config-create.sh && \
    chmod -R 0777 wp-content/

# If you don't include the -F flag, PHP-FPM typically runs 
# in the background as a daemon process, detaching from the 
# terminal session and continuing to run independently.
CMD ["/usr/sbin/php-fpm8", "-F"]
