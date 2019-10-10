# jAndBackup
Android backup and restore

##
- command line only
- encrypt data with gpg
- decryption for restore only on external device

```find ./ -type f -size +1c -name "*.tgg" -exec sh -c 'echo $1 && gpg --decrypt -o "${1%.tgg}.tgz" ${1}' _ {} \;```
- restore all apks and decrypted data
- restore only single apk with data for 1 user
