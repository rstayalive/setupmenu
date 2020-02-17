#!/bin/bash
#скрипт интеграции входящих звонков asterisk to slack с yandex поиском по организациям

touch /var/lib/asterisk/agi-bin/slackya.php
echo '#!/usr/bin/php -q
<?php
# парсим номер звонящего
error_reporting(0);
require('phpagi.php');
$agi = new AGI();
$cid = $agi->request['agi_callerid'];
$key = 'yaapikey';
$yandex_url = "https://search-maps.yandex.ru/v1/?text=$cid&results=1&type=biz&lang=ru_RU&apikey=$key";
$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL,$yandex_url);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 60);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
$yandex = curl_exec ($ch);
curl_close($ch);
$yandex_o = json_decode($yandex, true);
$addr = $yandex_o['features'][0]['properties']['CompanyMetaData']['address'];
$compname = $yandex_o['features'][0]['properties']['CompanyMetaData']['name'];
$webhook_url = 'https://hooks.slack.com/services/ваш_webhook_url';
$channel = "#general";
$username = "botname";
$icon_url = ":phone:";
$fields = "payload=" . json_encode(array(
"channel" => $channel,
"text" => "Коллеги, входящий звонок! \nНомер - $compname $cid \nАдрес - $addr",
"username" => $username,
"icon_url" => $icon_url
));
$ch = curl_init($webhook_url);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$result = curl_exec($ch);
curl_close($ch);
?> ' >> /var/lib/asterisk/agi-bin/slackya.php

echo -e "\nВведите slack webhook url"
read whu ;
replace "https://hooks.slack.com/services/ваш_webhook_url" "$whu" -- /var/lib/asterisk/agi-bin/slackya.php
echo -e "\nВведите API ключ yandex developer API поиска по организациям"
read yapi ;
replace "yaapikey" "$yapi" -- /var/lib/asterisk/agi-bin/slackya.php
echo -e "\nВведите название #канала(EN only) для уведомлений. Пример #calls"
read chan ;
replace "#general" "$chan" -- /var/lib/asterisk/agi-bin/slackya.php
echo -e "\nНапишите как обозвать бота? От этого имени он будет писать информацию в slack"
read botnm ;
replace "botname" "$botnm" -- /var/lib/asterisk/agi-bin/slackya.php

chmod 755 /var/lib/asterisk/agi-bin/slackya.php
chown asterisk:asterisk /var/lib/asterisk/agi-bin/slackya.php
dos2unix /var/lib/asterisk/agi-bin/slackya.php

echo '[from-pstn-custom]
exten => _.,n,AGI(slackya.php)' > /etc/asterisk/extensions_override_freepbx.conf
fwconsole chown
rasterisk -rx"dialplan reload"
