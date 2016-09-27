
#WORKLOADS="25 30"
WORKLOADS="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20"
WORKERS="8 9 10"
#WORKERS="7"
#SIZES="100 1024 4096 1048576"
SIZES="100"
RECORDS="1"
GETS="0"
SHARDS="2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20"
echo "sep=;" > nginx_results.csv

for shard in $SHARDS; do
	#stream=stream_`uuidgen`
	#curl -H "Content-Type:application/json" -H "X-igz-function:CreateStream" -d '{"ShardCount":'$shard',"ShardRetentionPeriodSizeMB":4096}' -X PUT http://10.10.1.14:8081/12/$stream -w "%{http_code}"
	for gets in $GETS; do
		for size in $SIZES; do
			for workload in $WORKLOADS; do
				for worker in $WORKERS; do
					for record in $RECORDS; do
			#./make_putrecord_payload.sh $size $workload
			#./make_putrecords_payload.sh $size $workload $record
			#./make_putitem_payload.sh $size $workload
			#./make_getitem_payload.sh $size $workload
			#./make_dynamo_workload.sh -n $workload -g 0 -w $worker -r 0 -d 20
			#./make_s3_workload.sh -n $workload -g 100 -w $worker -r 0 -d 20 -s s3-us-west-2.amazonaws.com -c iguazio-michael
			#./make_workload.sh -n $workload -g $gets -w $worker -r 0 -d 20 -s 10.10.1.14 -c 12 -p /tmp/payload
			stream=stream_`uuidgen`
		        curl -H "Content-Type:application/json" -H "X-igz-function:CreateStream" -d '{"ShardCount":'$shard',"ShardRetentionPeriodSizeMB":4096}' -X PUT http://10.10.1.14:8081/12/$stream -w "%{http_code}"
			./make_workload.sh -n $workload -g 0 -w $worker -r 0 -s 10.10.1.14 -c 12 -p /tmp/payload -d 20 -f $stream/ -h Content-Type="\"application/json"\",X-igz-function="\"PutRecords"\"
			#/opt/tools/nginx_loader/nginx_loader -c wl.tmp
			/home/iguazio/git/naipi_tools/nginx_loader/nginx_loader -c wl.tmp
			res=`echo $?`
			
			totalreq=`sed "2q;d" nginx_loader.results | cut -d "=" -f 2`
			totaliops=`sed "3q;d" nginx_loader.results | cut -d "=" -f 2`
			getreq=`sed "6q;d" nginx_loader.results | cut -d "=" -f 2`
			getiops=`sed "7q;d" nginx_loader.results | cut -d "=" -f 2`
			getlatmin=`sed "8q;d" nginx_loader.results | cut -d "=" -f 2`
			getlatmax=`sed "9q;d" nginx_loader.results | cut -d "=" -f 2`
			getlatavg=`sed "10q;d" nginx_loader.results | cut -d "=" -f 2`
			putreq=`sed "13q;d" nginx_loader.results | cut -d "=" -f 2`
			putiops=`sed "14q;d" nginx_loader.results | cut -d "=" -f 2`
			putlatmin=`sed "15q;d" nginx_loader.results | cut -d "=" -f 2`
			putlatmax=`sed "16q;d" nginx_loader.results | cut -d "=" -f 2`
			putlatavg=`sed "17q;d" nginx_loader.results | cut -d "=" -f 2`
			echo -ne "$workload;$worker;$size;$totalreq;$totaliops;$getreq;$getiops;$getlatmin;$getlatmax;$getlatavg;$putreq;$putiops;$putlatmin;$putlatmax;$putlatavg;$res;$record;$gets;$shard" >> nginx_results.csv
			echo "" >> nginx_results.csv

done
done
done
done
done
done
			
			
		

