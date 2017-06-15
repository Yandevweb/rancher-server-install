#!/bin/bash

cmdProxy='command'
command type -f sudo &> /dev/null && cmdProxy='sudo'

echo "Enter MYSQL user 'root' desire password : "
read -s passwd

# install MySQL
${cmdProxy} docker run --name mysql -e MYSQL_ROOT_PASSWORD=${passwd} -d mysql:latest

# Récupération de l'id de l'image mysql
idMysql="$(docker ps -aqf "name="mysql)"

# Construction de l'image apache
${cmdProxy} docker build -f imgApache -t apache .

# link des containers apache et mysql
docker run --name apache --link ${idMysql} -p 4000:80 -d apache

# Récupération de l'id de l'image apache
idApache="$(docker ps -aqf "name="apache)"

# Installation de PHPmyAdmin
${cmdProxy} docker run --name myadmin -d --link ${idMysql}:db -p 8080:80 phpmyadmin/phpmyadmin

# Installation de Rancher
${cmdProxy} docker run -d --restart=unless-stopped -p 8070:80 rancher/server
