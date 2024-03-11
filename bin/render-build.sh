#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# Install tailwindcss-rails gem and generate tailwind.config.js file
# ./bin/rails tailwindcss:install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:migrate:reset