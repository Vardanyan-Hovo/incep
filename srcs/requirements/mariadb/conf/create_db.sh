#!bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
#Checks if the directory "/var/lib/mysql/mysql" doesn't exist.
# If it doesn't exist, it proceeds with the following steps


        chown -R mysql:mysql /var/lib/mysql
#Changes the ownership of the "/var/lib/mysql" directory and its contents
#to the "mysql" user and group.

        mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
#Initializes the MySQL database using the "mysql_install_db" command
#with specified parameters.
 

	tfile=`mktemp`
#Creates a temporary file using the "mktemp" command and 
#assigns its path to the "tfile" variable.

	if [ ! -f "$tfile" ]; then
#Checks if the directory "/var/lib/mysql/wordpress" doesn't exist
#If it doesn't exist, it proceeds with the following steps:
		return 1
        fi
fi

if [ ! -d "/var/lib/mysql/wordpress" ]; then
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';:
# This command changes the password for the "root" user on the 
# "localhost" host to the value specified by the "${DB_ROOT}" variable.

        cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM     mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
#CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;:
# This command creates a new database with the name specified by the
# "${DB_NAME}" variable. It sets the character set to "utf8" and
# the collation to "utf8_general_ci", which are commonly used 
# settings for supporting multilingual data.


#Executes the SQL script using the "/usr/bin/mysqld" command with the 
#"--bootstrap" option and the script file as input.
 	/usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
        
#Removes the temporary SQL script file.
	rm -f /tmp/create_db.sql
fi
