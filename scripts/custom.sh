#!/bin/sh

echo ">>> Installing Custom scripts"

CHECK_APCU_INSTALL_FILE=/home/vagrant/.apcu_installed
if [ ! -f ${CHECK_APCU_INSTALL_FILE} ]; then

    # APC install
    yes '' | sudo pecl install apcu-beta

    # APCU Config
    cat > /etc/php5/fpm/conf.d/20-apcu.ini << EOF
    extension=apcu.so
    apc.enabled=1
EOF

    echo "installed" > ${CHECK_APCU_INSTALL_FILE}

fi

echo ">>> Installing Custom PHP ini"
sudo sed -i "s/error_reporting=E_ALL/error_reporting=E_ALL \& ~E_DEPRECATED \& ~E_STRICT/" /etc/php5/fpm/php.ini

sudo service php5-fpm restart

CHECK_WKHTMLTOPDF_INSTALL_FILE=/usr/bin/wkhtmltopdf
if [ ! -f ${CHECK_WKHTMLTOPDF_INSTALL_FILE} ]; then

    # Install wkhtmltopdf
    sudo apt-get -y install wkhtmltopdf
    sudo apt-get -y install xvfb
    echo 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' > /usr/bin/wkhtmltopdf.sh
    chmod a+rx /usr/bin/wkhtmltopdf.sh
    ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf

fi

sudo locale-gen de_DE.utf8
sudo locale-gen fr_FR.utf8
sudo locale-gen en_US.utf8
sudo locale-gen nl_NL.utf8

sudo service php5-fpm restart
sudo service apache2 restart
