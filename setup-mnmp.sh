#!/bin/bash

# install homebrew's official php tap
brew tap josegonzalez/homebrew-php
# install homebrew-dupes
brew tap homebrew/dupes

# install nginx + mysql + php 5.4 + php-fpm
# 1.nginx
brew install pcre
brew install nginx

sudo mkdir /var/log/nginx
sudo mkdir /var/lib/nginx

mkdir /usr/local/etc/nginx/vhost/

# 2.php
brew install php55 --with-imap --with-tidy --with-debug --with-pgsql --with-mysql --with-fpm
# brew options php54 # see more options
brew install php55-mcrypt
brew install php55-xhprof
brew install php55-xdebug
brew install php55-uploadprogress

# echo 'export PATH="$(brew --prefix php54)/bin:$PATH" # php' >> ~/.bash_profile

# 
brew install mariadb --use-llvm --env=std

# set up mysql to run as user account
unset TMPDIR
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mariadb)" --datadir=/usr/local/var/mysql --tmpdir=/tmp

sudo chown -R $(whoami) /usr/local/var/mariadb/
