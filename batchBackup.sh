#!/system/bin/sh

PATH=/system/xbin:$PATH

if [ ! -e /sdcard/jAndBackup ]; then mkdir /sdcard/jAndBackup; fi
if [ ! -e /sdcard/log ]; then mkdir /sdcard/log; fi
/data/jpchil/jAndBackup/jAndBackup.sh I 2 >> /data/jpchil/log/jAndBackup.err
find /sdcard/jAndBackup/ -mtime -1 | wc -l > /sdcard/log/jAndBackup.count
# sync jAndBackup to us.jpchil.at
/data/jpchil/unison/jDeviceSync.sh "" B
