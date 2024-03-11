#!/bin/bash
set -e

rm -f /myapp/tmp/pids/server.pid

# if [ $RAILS_ENV = 'production' ]; then
#   bundle exec rails assets:precompile
#   bundle exec rails assets:clean
#   bundle exec rails db:migrate
# fi

exec "$@"