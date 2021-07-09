#!/bin/bash

if ! test -e ${project_dir-/var/www/html}/vendor; then
  echo "composer install"
  composer install ${install_params--o --no-dev -d ${project_dir-/var/www/html}}
else
  echo "project already installed"
fi

echo "start apache2"
docker-php-entrypoint apache2-foreground