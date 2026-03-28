#!/usr/bin/env bash
set -o errexit

echo "==> Installing gems"
bundle install

echo "==> Building Tailwind CSS"
bundle exec tailwindcss \
  --input app/assets/tailwind/application.css \
  --output app/assets/builds/tailwind.css \
  --minify

echo "==> Precompiling assets"
SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

echo "==> Cleaning old assets"
bundle exec rails assets:clean

echo "==> Running migrations"
bundle exec rails db:migrate

echo "==> Done"
