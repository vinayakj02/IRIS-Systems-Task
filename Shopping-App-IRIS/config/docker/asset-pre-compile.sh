#! /bin/sh

# Precompile assets for production
bundle exec rake assets:precompile
bundle exec rails credentials:edit

# RAILS_ENV=production bundle exec rake assets:precompile

echo "Assets Pre-compiled!"