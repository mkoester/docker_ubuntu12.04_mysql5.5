FROM ubuntu:12.04
MAINTAINER Mirko Köster "it@mirkokoester.de"
ENV REFRESHED_AT 2014-08-15

# MySQL root password:
ENV MYSQL_ROOT_PW root

# DB user & password
ENV DB_USER dbuser
ENV DB_USER_PW password

# Database to create
ENV DB_NAME my_database

# Install the relevant packages
RUN echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PW" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PW" | debconf-set-selections
RUN apt-get -yqq update && apt-get -yqq install mysql-server

#make the server listen on all interfaces
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# allow user '$DB_USER' to connect over the network
RUN /usr/sbin/mysqld & \
    sleep 3s &&\
    echo "GRANT ALL ON *.* TO $DB_USER@'%' IDENTIFIED BY '$DB_USER_PW' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql -u root --password=$MYSQL_ROOT_PW &&\
# create a database
    echo "CREATE DATABASE \`$DB_NAME\` CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -u root --password=$MYSQL_ROOT_PW

# expose port 3306 so that one can access mysql
EXPOSE 3306

# Execute the mysql daemon in the foreground so we can treat the container as an
# executeable and it wont immediately return.
ENTRYPOINT [ "/usr/sbin/mysqld" ]
CMD []

