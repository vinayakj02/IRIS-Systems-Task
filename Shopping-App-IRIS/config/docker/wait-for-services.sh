#! /bin/sh

apt-get -y install netcat 
# Wait for MySQL
until nc -z -v -w30 $DB_HOST $DB_PORT; do
 echo 'Waiting for MySQL...'
 sleep 1
done
bundle exec rails credentials:edit
echo "MySQL is up and running!"