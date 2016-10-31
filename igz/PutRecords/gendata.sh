#/bin/bash
if [ $# -ne 2 ]; then echo incorrect usage; exit 1; fi
file=$1
size=$2
echo -n \{\"Records\":\[\{\"Data\": \" > $file
data=`dd if=/dev/urandom bs=1 count=$size|base64`
echo -n $data|sed 's/ //g'  >> $file
echo -n \"\}\]} >> $file
