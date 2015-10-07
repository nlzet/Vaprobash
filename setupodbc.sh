#!/bin/bash

# install tools + php module
apt-get -y install freetds-bin freetds-common tdsodbc odbcinst php5-odbc unixodbc
apt-get -y install libmdbodbc1

# configure data source with DriverName found in /etc/odbcinst.ini (default MDBTools)
sudo cat >> /etc/odbc.ini << EOF
[dbname]
Description = dbname
Driver = MDBTools
Servername = localhost
Database = /path-to-file.accdb
UserName =
Password =
port = 5432
EOF

# test connection
# isql -v beheerw

#<?php
#try{
#    $db = new PDO("odbc:DSN=beheerw;");
#    var_dump($db);
#    $stmt = $db->prepare('SELECT * FROM KB_Land_met_Provincie');
#    $stmt->execute();
#    while($obj = $stmt->fetchObject()){
#        var_dump($obj);
#    }
#}
#catch(PDOException $e){
#    echo $e->getMessage();
#}
#exit();
