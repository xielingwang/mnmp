#!/bin/bash


# echo "alias mnmp='/Users/leon/leon/bash/mnmp.sh'" >> ~/.bash_profile
# mnmp start | stop | restart


NGINX="/usr/local/bin/nginx"
PHPFM="/usr/local/Cellar/php55/5.5.12/sbin/php-fpm"

PIDPATH="/usr/local/var/run"

NGINX_PID="$PIDPATH/nginx.pid"
stop_nginx() {
    if [ -f "$NGINX_PID" ]; then
        printf "nginx stopping... killing pid="
        cat "$NGINX_PID"
        sudo "$NGINX" -s stop
        printf "   Done!\n"
    else
        printf "no nginx running!\n"
        return
    fi
}
start_nginx() {
    if [ -f "$NGINX_PID" ]; then
        printf "nginx running!\n"
        return 1
    else
        printf "nginx starting..."
        sudo "$NGINX"
        printf "   Done!\n"
    fi
}

reload_nginx() {
    if [ -f "$NGINX_PID" ]; then
        printf "reload nginx.. "
        sudo `"$NGINX"` -s reload
        printf "   Done!\n"
    else
        printf "no nginx running!\n"
        return
    fi
}

FPM_PID="$PIDPATH/php-fpm.pid"
stop_phpfpm() {
    if [ -f "$FPM_PID" ]; then
        printf "php-fpm stopping... killing pid="
        cat "$FPM_PID"
        sudo kill `cat "$FPM_PID"`
        printf "   Done!\n"
    else
        printf "no running php-fpm!\n"
        return 1
    fi
}
start_phpfpm() {
    if [ -f "$FPM_PID" ]; then
        printf "php-fpm running!\n"
        return 1
    else
        printf "php-fpm starting..."
        sudo "$PHPFM" -D -y /usr/local/etc/php/5.5/php-fpm.conf
        printf "   Done!\n"
    fi
}

stop_mariadb() {
  printf "stopping mariadb..\n"
  sudo mysqladmin shutdown -u root -p
  printf "   Done!\n"
}
start_mariadb() {
  printf "starting mariadb..\n"
  sudo nohup sudo mysqld_safe &
  printf "   Done!\n"
}

start()
{
    start_nginx
    start_phpfpm
    start_mariadb
}
 
stop()
{
    stop_phpfpm
    stop_nginx
    stop_mariadb
}

param=$1
case $param in
    'restart_nginx')
        stop_nginx
        start_nginx;;
    'restart_php')
        stop_phpfpm
        start_phpfpm;;
    'restart_mariadb')
        stop_mariadb
        start_mariadb;;
    'start')
        start;;
    'stop') 
        stop;;
    'restart')
        stop
        start;;
    'reload')
        reload_nginx;;
    *)
    echo "Usage: ./mnmp.sh start | stop | restart | reload | restart_nginx | restart_php | restart_mariadb";;
esac