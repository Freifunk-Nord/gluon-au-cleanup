#!/bin/sh
PATH=/usr/sbin:/usr/bin:/sbin:/bin

# Path for wget to download the file with the router MAC as filename:
UPD='http://[fd42:eb49:c0b5:4242::fd00]/ffffng-transfer'

#this has to be done on the fastd-gateway:
#for i in /home/fastform/fastdkeys/*; do echo $i;  \
#  MAC=$(egrep "MAC" "$i" |cut -d\  -f3);  \
#  LAT="$(egrep "Koordinaten" "$i" |cut -d\  -f3)"; \
#  LON="$(egrep "Koordinaten" "$i" |cut -d\  -f4)"; \
#  H="$(egrep "Knotenname" "$i" |cut -d\  -f3-9)"; \
#  O="$(egrep "Kontakt" "$i" |cut -d\  -f3-9|md5sum |head -c10)"; \
#  M="$(egrep "Monitoring: pending|Monitoring: aktiv" "$i" |cut -do -f1|cut -d \  -f2)"; \
#  echo 'H="'"$H"'";LAT="'"$LAT"'";LON="'"$LON"'";O="'"$O$M"'"' > /var/www/html/opkg/ffffng-transfer/$MAC; done

MAC="$(uci get network.client.macaddr | tr \[a-z] [A-Z])"
wget -q -6 $UPD/$MAC -O /tmp/a
source /tmp/a

if [ $H ]; then 
  uci set system.@system[0].hostname="$H"
  uci commit system
fi
if [ $LAT ]; then
  uci set gluon-node-info.@location[0].latitude="$LAT"
  uci set gluon-node-info.@location[0].longitude="$LON"
  uci set gluon-node-info.@location[0].share_location="1"
fi
if [ $O ]; then
  uci set gluon-node-info.@owner[0].contact="$O"
  uci commit gluon-node-info
  # delete the cronjob
  rm /usr/lib/micron.d/ffffng-transfer-once
  /etc/init.d/micrond restart
  logger -s -t "ffffng-transfer-once" -p 5 "update"
fi
