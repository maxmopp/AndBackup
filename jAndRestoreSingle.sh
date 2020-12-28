#!/system/xbin/ash
#
# 20190205 /jps - restore jAndBackups
# 20191005  add $User
# 20200627 for A10 apks have to be installed for users other than 0 explicitly (pm --user 10)
#
# How:
# pm list packages | grep car2 | awk -F\: '{ print "./jAndRestoreSingle " $2 " 0 Y" }' | ash

# ACHTUNG: this down not work if jumping package install - very bad ownership messup

# $1  .... package to restore
# $2  .... user to restore it for
# $3  .... tgz Directory
# $4  .... YN to all questions

AutoA=$(echo $4 | tr '[:lower:]' '[:upper:]')

if [ "$1" == "" ]; then echo "Package spec *name* "; exit; fi

if [ "$2" == "" ]; then echo "User spec missing"; exit; fi
Result=$(pm list packages --user $2)                                                                             
if [ "$Result" == "" ]; then echo "No such user: $2"; fi
User=$2

BackDir="/sdcard/jAndBackup"
if [ "$3" != "" ]; then BackDir=$3; fi
echo "Source: $BackDir"

ApkTar=$(find $BackDir/*$1*apk.tgz | tail -1)
Package=$(echo $ApkTar | sed 's/.*\/\(.*\)-apk.tgz/\1/')
if [ "$Package" == "" ]; then echo "Package $Package not found"; exit; fi
if [ "$AutoA" = "" ]; then
  printf "Restore $ApkTar for user $User (Y/N) "
  read YesNo
  Answer=$(echo $YesNo | tr '[:lower:]' '[:upper:]')
else
  Answer=$AutoA
fi
if [ "$Answer" = "Y" ]; then 
  # restore apk                         
  tar -vxzpf $ApkTar -C /               
  find /data/app/$Package*/ -name base.apk -exec pm install --user $User -r {} \;
fi
                                                               
# restore data  
if [ "$AutoA" = "" ]; then
  printf "Restore $Package data for User $User (Y/N)"
  read YesNo
  Answer=$(echo $YesNo | tr '[:lower:]' '[:upper:]')
else
  Answer=$AutoA                                                     
fi
if [ "$Answer" != "Y" ]; then exit; fi                                     
find $BackDir/$Package*User$User.tgz -exec tar -vxzpf {} -C / \;   
PUid=$(cmd package list packages -U $Package | awk -v User=${User} -F: '{ print "u"User"_"$3 }' \
  | sed 's/_10/_a/g' | sed 's/_11/_b/g' | sed 's/_12/_c/g' | sed 's/_13/_d/g' \
  | sed 's/_14/_e/g' | sed 's/_15/_f/g')
chown -R $PUid:$PUid /data/user*/*/$Package
