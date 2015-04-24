#!/usr/bin/env bash

echo ">>> Installing PhpMyAdmin"

URL=http://switch.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.4.3/phpMyAdmin-4.4.3-all-languages.tar.bz2
FILE=${URL##*/}
TARGET=/opt/phpmyadmin

[ ! -f /tmp/${FILE} ] && wget -nv ${URL} -O /tmp/${FILE}

for dir in `find /opt/ -name "phpM*" -type d`;
do
    rm -Rf $dir
done

[ ! -d ${TARGET} ] && mkdir $TARGET

tar -xjf /tmp/${FILE} -C ${TARGET}

for dir in `ls /opt/phpmyadmin`;
do
    rm /vagrant/phpmyadmin
    ln -s ${TARGET}/$dir/ /vagrant/phpmyadmin
done

cat <<< '<?php
$cfg['blowfish_secret'] = ''; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'config';
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['user'] = 'root';
$cfg['Servers'][$i]['password'] = '';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = true;
' > /vagrant/phpmyadmin/config.inc.php
