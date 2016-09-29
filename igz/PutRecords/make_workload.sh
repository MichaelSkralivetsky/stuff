#!/bin/bash

show_help() {
	echo "Workload file generator for nginx_loader, make sure that r_$n files exist before running benchmark"
	echo "Usage: -n [num of workloads] -g [% of GETs] -w [num of workers per workload] -r [0|1, 1=work on random files] -s [server IP] -c [container id] -p [payload file path] -d [duration, sec] -f [filepath] -h [headers]"
	echo -e "Example: ./make_workload.sh -n 200 -g 100 -w 10 -r 0 -s 10.10.1.14 -c 12 -p /tmp/payload -d 20 -f walla4/0 -h Content-Type="\"\\\"application/json"\"\\\",X-igz-function="\"\\\"PutRecords"\"\\\""
	echo "wl.tmp workload file will be generated in current directory, default filepath=r_i if not specified"
	exit 1
}

if [ -z $1 ]; then
        show_help
	exit 1
fi

OPTIND=1
while getopts ":h:n:g:w:r:s:c:p:d:f:h:" opt; do
	 case "$opt" in
		n)
			load=${OPTARG}
			;;
		g)
			g=${OPTARG};;
		w)
			w=${OPTARG};;
		r)
			r=${OPTARG}
			((r == 0 || r == 1)) || show_help
			if [ $r -eq 1 ]; then
				random_files=1
			fi
			;;
		s)	
			s=${OPTARG};;
		c)
			c=${OPTARG};;
		p)
			p=${OPTARG};;
		d)
			d=${OPTARG}
			d+="s"
			;;
		f)
			f=${OPTARG};;
		h)
			h=${OPTARG};;
		*)
                        show_help
                        exit 0
                        ;;
	esac
done

shift $((OPTIND-1))


truncate -s 0 wl.tmp
echo -e "[global]\nduration="\"3600s"\"\nNGINX_SERVER="\"$s"\"\nNGINX_PORT="\"8081"\"\n[workloads]" >> wl.tmp

let gets=load*g/100
let puts=load-gets

function pick_random_index {
	
	index=$((RANDOM % $load))
}

if [ -n "$h" ]; then
	headers=$(echo $h | tr "," "\n")
fi

if [ -z $random_files ]; then

	#generate GET's
	
	for ((i=0;i<$gets;i++)); do
		if [ -z $f ]; then
			path=r_$i
		else
			path=$f
		fi
		echo -e "\n\t[workloads.load$i]\n\tcount=0\n\theader="\"{}"\"\n\tname="\"load$i"\"\n\tduration="\"$d"\"\n\ttype="\"GET"\"\n\tworkers=$w\n\tbucket="\"$c"\"\n\tfile_path="\"$path"\"\n\tpayload="\"\""" >> wl.tmp;
		if [ -n "$h" ]; then
                        echo -e "\n\t[workloads.load$i.Header]" >> wl.tmp;
			for header in $headers; do
				echo -e "\t$header" >> wl.tmp;
			done
                fi
	done

	#generate PUT's
	for ((i=$gets;i<$load;i++)); do
		if [ -z $f ]; then
                        path=r_$i
                else
                        path=$f
                fi
        	echo -e "\n\t[workloads.load$i]\n\tcount=0\n\theader="\"{}"\"\n\tname="\"load$i"\"\n\tduration="\"$d"\"\n\ttype="\"PUT"\"\n\tworkers=$w\n\tbucket="\"$c"\"\n\tfile_path="\"$path"\"\n\tpayload="\"$p\""" >> wl.tmp;
		if [ -n "$h" ]; then
                        echo -e "\t[workloads.load$i.Header]" >> wl.tmp;
			for header in $headers; do
                                echo -e "\t$header" >> wl.tmp;
                        done
                fi
	done
else
	### "going random"
	#generate GET's
        for ((i=0;i<$gets;i++)); do
		pick_random_index
                echo -e "\n\t[workloads.load$i]\n\tcount=0\n\theader="\"{}"\"\n\tname="\"load$i"\"\n\tduration="\"$d"\"\n\ttype="\"GET"\"\n\tworkers=$w\n\tbucket="\"$c"\"\n\tfile_path="\"r_$index"\"\n\tpayload="\"\""" >> wl.tmp;
        done

        #generate PUT's
        for ((i=$gets;i<$load;i++)); do
		pick_random_index
                echo -e "\n\t[workloads.load$i]\n\tcount=0\n\theader="\"{}"\"\n\tname="\"load$i"\"\n\tduration="\"$d"\"\n\ttype="\"PUT"\"\n\tworkers=$w\n\tbucket="\"$c"\"\n\tfile_path="\"r_$index"\"\n\tpayload="\"$p\""" >> wl.tmp;
        done

fi


      
