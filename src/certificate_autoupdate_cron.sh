#!/bin/bash
# cert check on https://127.0.0.1
email='myemail'
expire_date=$(curl --insecure -v https://127.0.0.1 2>&1 | grep 'expire date' | cut -d':' -f2-)
start_date=$(curl --insecure -v https://127.0.0.1 2>&1 | grep 'start date' | cut -d':' -f2-)
expire_timestamp=$(date -d"$expire_date" +%s)
current_timestamp=$(date +%s)
days_until_expire=$(( ($expire_timestamp - $current_timestamp) / (60*60*24) ))

# expire date < 10 from current time
if [ $days_until_expire -lt 10 ]; then
    echo "SSL less 10 days to be expired."
    # refreshing cert
   fwconsole certificates --updateall --force && fwconsole chown && fwconsole restart
   #addition restart for itgrix
if systemctl list-units --all | grep -q 'itgrix_bx\|itgrix_amo'; then
    echo "itgrix found. trying restart itgrix "
    # restarting if itgrix installed
    systemctl restart itgrix_bx || true
    systemctl restart itgrix_amo || true
    echo "itgrix restarted"
else
    echo "itgrix not installed"
fi
else
    echo -e "Дата начала действия сертификата$start_date Дата окончания действия сертификата$expire_date" |mail -s "Сертификат скоро закончится прими меры! $(hostname)" -r asterisk$(hostname) $email
fi
exit 0