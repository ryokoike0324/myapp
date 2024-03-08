#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# Install tailwindcss-rails gem and generate tailwind.config.js file
./bin/bundle add tailwindcss-rails
./bin/rails tailwindcss:install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate