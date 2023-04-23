#!/bin/sh
service nginx start
service php8.1-fpm start
LOG "Wordpress Init Completed"

exit 0