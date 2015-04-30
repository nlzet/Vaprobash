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

sudo service php5-fpm restart

# Install wkhtmltopdf
sudo apt-get -y install wkhtmltopdf
sudo apt-get -y install xvfb
echo 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' > /usr/bin/wkhtmltopdf.sh
chmod a+rx /usr/bin/wkhtmltopdf.sh
ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf
