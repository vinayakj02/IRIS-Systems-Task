#! /bin/sh

# If the database exists, migrate. Otherwise setup (create and migrate)
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:create db:migrate
# bundle exec rails credentials:edit
echo "Done!"