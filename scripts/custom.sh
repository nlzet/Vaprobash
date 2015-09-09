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

    # wkhtmltopdf
    sudo apt-get install -y software-properties-common python-software-properties xfonts-75dpi
    sudo wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
    sudo dpkg -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
    sudo apt-get -f install

    # Install xvfb monitor
    sudo apt-get -y install xvfb
    echo 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/local/bin/wkhtmltopdf $*' > /usr/bin/wkhtmltopdf.sh
    chmod a+rx /usr/bin/wkhtmltopdf.sh
    sudo ln -s /usr/bin/wkhtmltopdf.sh /usr/bin/wkhtmltopdf
fi

echo ">>> Installing Custom server locale's for php i18n"

sudo locale-gen de_DE.utf8
sudo locale-gen fr_FR.utf8
sudo locale-gen en_US.utf8
sudo locale-gen nl_NL.utf8

sudo service php5-fpm restart
sudo service apache2 restart

echo ">>> Installing Custom Node and node packages"

sudo apt-get install -y nodejs npm nodejs-legacy
sudo npm install -g bower grunt grunt-cli
