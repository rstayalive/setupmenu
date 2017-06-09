#!/bin/bash
#Скрипт создания самоподписанного сертификата
#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

cd /etc/asterisk
echo "Создаю самоподписанный сертификат для простых звонков"
mv dh512.pem dh512.pem_back
openssl dhparam -out dh512.pem 2048
echo "Создаю новый сертификат"
openssl req -new -x509 -days 1095 -newkey rsa:1024 -sha256 -nodes -keyform PEM -keyout privkey1.pem -outform PEM -out newsert.pem -config <(echo -e '[req]\nprompt=no\nreq_extensions=req_ext\ndistinguished_name=dn\n[dn]\nC=RU\nST=Russia\nL=Moscow\nO=vedisoft\nOU=prostiezvonki\nCN=asterisk\n[req_ext]\nsubjectAltName=DNS:asterisk') -extensions req_ext
echo -e "$GREВсе готово!$DEF"
wait