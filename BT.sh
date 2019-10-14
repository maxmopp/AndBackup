# Turn BT off
service call bluetooth_manager 8

# Change BT Adapter Address
BtA=$(settings get secure bluetooth_address)
sed -i -E '/\[Adapter\]/,/\[/{s/Address = [0-9a-fA-F:]{17}/Address = '$BtA'/g}' /data/misc/bluedroid/bt_config.conf 

# add backuped pairings from /data/misc/bluedroid/bt_config.xml
sed '1,$s/^.*Tag=\"\(.*\)/\1 = /g' bt_config.xml | \
sed '1,$s/\" Type=\".*\">\(.*\)<.*/ = \1/g' | \
sed '1,$s/^\(.*\):\(..\)\".*/[\1:\2]/' | \
sed 's/<.*>//g' | \
sed 's/Trusted.*//g' | \
sed '/Local/,/Remote/{/^\$/!d}' >> /data/misc/bluedroid/bt_config.conf

