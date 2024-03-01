FROM alpine:3.16

ARG DB_NAME \
    DB_USER \
    DB_PASS

RUN apk update && apk add --no-cache mariadb mariadb-client

#This can be useful when dealing with dynamic
# environments where hostnames may change frequently.
#1 "skip-host-cache": This option tells MySQL to 
#   skip DNS hostname resolution caching.

#2 "skip-name-resolve": This option instructs 
#   MySQL to skip DNS name resolution 
#   for client connections.

#3  "bind-address=0.0.0.0": This option sets the MySQL server
#    to listen on all available network interfaces,
#    allowing connections from any IP address.

RUN mkdir /var/run/mysqld; \
chmod 777 /var/run/mysqld; \
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf
#creates a directory named "mysqld" for It is used to 
#store the MySQL server's runtime information.


#"skip-host-cache": This option tells MySQL to skip DNS hostname resolution caching.



RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

COPY requirements/mariadb/conf/create_db.sh .
RUN sh create_db.sh && rm create_db.sh
USER mysql
CMD ["/usr/bin/mysqld", "--skip-log-error"]
