#/bin/bash
mkdir -p /root/geoipupd
cd /root/geoipupd
cp /root/setupmenu/src/geoip.zip .
wget "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country-CSV&license_key=n0eIgItIDa4q&suffix=zip" -O GeoLite2-Country-CSV.zip
unzip GeoLite2-Country-CSV.zip
mv GeoLite2-Country-CSV*/ geoiplite
unzip geoip.zip
cp geoiplite/GeoLite2-Country-Blocks-IPv4.csv geoip/
cp geoiplite/GeoLite2-Country-Locations-en.csv geoip/
cd /root/geoipupd/geoip/
chmod +x xt_geoip_build
./xt_geoip_build GeoLite2-Country-Blocks-IPv4.csv
./xt_geoip_build GeoLite2-Country-Locations-en.csv
mkdir -p /usr/share/xt_geoip/
yes | cp -rf {BE,LE} /usr/share/xt_geoip/
modprobe xt_geoip
echo "done"

#/bin/bash
mkdir -p /root/geoipupd
wget "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=n0eIgItIDa4q&suffix=tar.gz" -O base.tar.gz
tar zxvf base.tar.gz
mv GeoLite2-Country*/ geoip
mv geoip/GeoLite2-Country.mmdb /usr/share/GeoIP/
echo "LicenseKey n0eIgItIDa4q
UserId 223481
ProductIds GeoLite2-Country" > /etc/GeoIP.conf
geoipupdate -v