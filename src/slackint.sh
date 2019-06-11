#!/bin/bash
#скрипт интеграции asterisk и slack без яндекса. Все входящие звонки падают в канал.

touch /var/lib/asterisk/agi-bin/slack.php
echo '#!/usr/bin/php -q
<?php
# парсим номер звонящего
error_reporting(0);
require('phpagi.php');
$agi = new AGI();
$cid = $agi->request['agi_callerid'];
$webhook_url = 'https://hooks.slack.com/services/ваш_webhook_url';
$channel = "#general";
$username = "botname";
$icon_url = ":phone:";
$fields = "payload=" . json_encode(array(
"channel" => $channel,
"text" => "Коллеги, входящий звонок! \nЗвонящий - $cid",
"username" => $username,
"icon_url" => $icon_url
));
$ch = curl_init($webhook_url);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$result = curl_exec($ch);
curl_close($ch);
?> ' >> /var/lib/asterisk/agi-bin/slack.php

echo -e "\nВведите slack webhook url"
read whu ;
replace "https://hooks.slack.com/services/ваш_webhook_url" "$whu" -- /var/lib/asterisk/agi-bin/slack.php
echo -e "\nВведите название #канала(EN only) для уведомлений. Пример #calls"
read chan ;
replace "#general" "$chan" -- /var/lib/asterisk/agi-bin/slack.php
echo -e "\nНапишите как обозвать бота? От этого имени он будет писать информацию в slack"
read botnm ;
replace "botname" "$botnm" -- /var/lib/asterisk/agi-bin/slack.php

chmod 755 /var/lib/asterisk/agi-bin/slack.php
chown asterisk:asterisk /var/lib/asterisk/agi-bin/slack.php
dos2unix /var/lib/asterisk/agi-bin/slack.php 

echo '[from-pstn-custom]
exten => _.,n,AGI(slack.php)' > /etc/asterisk/extensions_override_freepbx.conf
fwconsole chown
rasterisk -rx"dialplan reload"