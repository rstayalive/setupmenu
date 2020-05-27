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