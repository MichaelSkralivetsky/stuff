
#WORKLOADS="25 30"
WORKLOADS="80 90 100 110 120 130 140 150 160 170 180"
WORKERS="13 17 19 20"
#WORKERS="7"
#SIZES="100 1024 4096 1048576"
SIZES="4096"
RECORDS="1"
GETS="0 50 100"
echo "sep=;" > nginx_results.csv

for gets in $GETS; do
for size in $SIZES; do
	for workload in $WORKLOADS; do
		for worker in $WORKERS; do
			for record in $RECORDS; do
			./make_workload.sh -n $workload -g $gets -w $worker -r 0 -d 20 -s 10.10.1.14 -c 12 -p /tmp/payload
			/opt/tools/nginx_loader/nginx_loader -c wl.tmp
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
			echo -ne "$workload;$worker;$size;$totalreq;$totaliops;$getreq;$getiops;$getlatmin;$getlatmax;$getlatavg;$putreq;$putiops;$putlatmin;$putlatmax;$putlatavg;$res;$record;$gets" >> nginx_results.csv
			echo "" >> nginx_results.csv

done
done
done
done
done
			
			
		

