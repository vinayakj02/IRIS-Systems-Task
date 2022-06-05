#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid
/etc/init.d/mysql stop
mysqld_safe --init-file=/tmp/mysql-init.sql &
/etc/init.d/mysql stop
/etc/init.d/mysql start 
export SHOP1_DATABASE_PASSWORD='mynewpassword'
rake db:create
rake db:migrate 

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
