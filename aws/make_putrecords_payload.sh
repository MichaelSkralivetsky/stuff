
#dd if=/dev/urandom of=tmp100 bs=$size count=1
#a=`cat tmp100 | base64 | sed 's/ //g'`
#echo "{"PartitionKey": "1234", "Data": "$a", "StreamName": "michael-test"}" > payload.test

file=payload.tmp
size=$1
num_files=$2
records=$3
declare -a keys=(1 2 3 4 5 6 7 -1 9 10 11 12 -2 14 15 -3 17 -25 19 20 21 22 23 -15 -5 26 27 -6 -9 53 61 60 140 66 85 58 89 95 90 86 133 149 117 91 -230 -244 -262 -204 255 256)
for ((i=0;i<$num_files;i++)); do
	filename=payload$i
	truncate -s 0 $filename
	#key=`/usr/bin/uuidgen`
	#key=`echo $key | sed -r 's/-//g'`
	key=${keys[$i]}
	echo -n "{"\"Records"\": [" > $file
	for ((j=0;j<$records;j++)); do
		echo -n "{"\"PartitionKey"\": "\"$key"\", "\"Data"\": \"" >> $file
		data=`dd if=/dev/urandom bs=1 count=$size|base64`
		echo -n "$data"|sed 's/ //g'  >> $file
		echo -n ""\"},"" >> $file
	done
	truncate -s -1 $file
	echo -n "],"\"StreamName"\": "\"michael-test"\"}" >> $file
	cat payload.tmp | tr -d '\n' > $filename

done
