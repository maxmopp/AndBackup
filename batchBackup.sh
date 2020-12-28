#!/system/bin/sh
if [ ! -e /sdcard/jAndBackup ]; then mkdir /sdcard/jAndBackup; fi
if [ ! -e /sdcard/log ]; then mkdir /sdcard/log; fi
/data/jpchil/jAndBackup/jAndBackup.sh I >> /data/jpchil/log/jAndBackup.log 2>&1
find /sdcard/jAndBackup/ -mtime -1 | wc -l > /sdcard/log/jAndBackup.count
