#!/usr/bin/env bash

echo ">>> Installing PhpMyAdmin"

PMA_VERSION=4.4.3
URL=downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.tar.bz2
FILE=${URL##*/}
TARGET=/opt/phpmyadmin

if [ ! -f /tmp/${FILE} ]; then
    wget -nv ${URL} -O /tmp/${FILE}

    for dir in `find /opt/ -name "phpM*" -type d`;
    do
        rm -Rf $dir
    done

    [ ! -d ${TARGET} ] && mkdir $TARGET

    tar -xjf /tmp/${FILE} -C ${TARGET}

    for dir in `ls /opt/phpmyadmin`;
    do
        # Override default config
        cat > /etc/apache2/sites-enabled/192.168.22.10.conf <<END
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName 192.168.22.10
    ServerAlias devserver.dev

    DocumentRoot /vagrant

    Alias /phpmyadmin "${TARGET}/$dir/"

    <Directory "${TARGET}/$dir/">
        Order allow,deny
        Allow from all
        Require all granted

        <FilesMatch \.php$>
            SetHandler "proxy:fcgi://127.0.0.1:9000"
        </FilesMatch>
    </Directory>

    <Directory /vagrant>
        Options +Indexes +FollowSymLinks +MultiViews
        AllowOverride All
        Require all granted

        <FilesMatch \.php$>
            SetHandler "proxy:fcgi://127.0.0.1:9000"
        </FilesMatch>
    </Directory>

    LogLevel warn
</VirtualHost>
END

    done

    cat > ${TARGET}/$dir/config.inc.php <<"END"
<?php
$cfg['blowfish_secret'] = '';
$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'config';
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['user'] = 'root';
$cfg['Servers'][$i]['password'] = '';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = true;

$cfg['UploadDir'] = '/vagrant/';
$cfg['SaveDir'] = '/vagrant/';

END

fi

sudo service apache2 restart
