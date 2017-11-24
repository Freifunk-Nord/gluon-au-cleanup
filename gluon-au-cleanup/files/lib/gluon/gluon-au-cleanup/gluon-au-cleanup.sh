#!/bin/sh
PATH=/usr/sbin:/usr/bin:/sbin:/bin


cat <<'EOF' >> /etc/config/autoupdater

config autoupdater 'settings'
        option enabled '1'
        option branch 'stable'
        option version_file '/lib/gluon/release'

config branch 'stable'
        list mirror 'http://[fd42:eb49:c0b5:4242::fd00]/firmware/stable/sysupgrade/'
        list mirror 'http://[fd42:eb49:c0b5:4242::fd01]/firmware/stable/sysupgrade/'
        list mirror 'http://[fd42:eb49:c0b5:4242::fd02]/firmware/stable/sysupgrade/'
        list mirror 'http://0.update.ffnord/firmware/stable/sysupgrade/'
        list mirror 'http://1.update.ffnord/firmware/stable/sysupgrade/'
        list mirror 'http://2.update.ffnord/firmware/stable/sysupgrade/'
        list mirror 'http://update.freifunknord.de/firmware/stable/sysupgrade/'
        option good_signatures '2'
        option name 'stable'
        list pubkey 'bbb814470889439c04667748c30aabf25fb800621e67544bee803fd1b342ace3'
        list pubkey '1d37eacbd70f72730b1f5aba246a6a8eab100e2d45dda0163d9ad827f70f88d4'
        list pubkey '589695821488c9acd2efc26c2fdde259b25615cbfdbb6a434e95e33fa6932023'
        list pubkey '9885f836464abf3633f92701e4febeefec54f481d8b6cd39085e6ad24162ff82'
        list pubkey '359ec3619184f1bdfe26515cf5ba2b016ba23489db2a371cbf5c3cee9d061110'
EOF
chmod 0644 /etc/config/autoupdater
rm /usr/lib/micron.d/gluon-au-cleanup
/etc/init.d/micrond restart
logger -s -t "gluon-au-cleanup" -p 5 "update"
