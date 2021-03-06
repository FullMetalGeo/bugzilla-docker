#!/bin/bash -ex
eval $(aws-env)

./checksetup.pl
sed -i \
    -e "s/^\$webservergroup = '.*';/\$webservergroup = 'www-data';/g" \
    -e "s/^\$db_driver = '.*';/\$db_driver = 'Pg';/g" \
    -e "s/^\$db_name = '.*';/\$db_name = 'bugzilla';/g" \
    -e "s/^\$db_user = '.*';/\$db_user = '${DB_USERNAME}';/g" \
    -e "s/^\$db_pass = '.*';/\$db_pass = '${DB_PASSWORD}';/g" \
    -e "s/^\$db_host = '.*';/\$db_host = '${DB_HOST}';/g" \
    -e "s/^\$site_wide_secret = '.*';/\$site_wide_secret = '${SITE_WIDE_SECRET}';/g" \
    localconfig
./checksetup.pl

/usr/sbin/apachectl -DFOREGROUND
