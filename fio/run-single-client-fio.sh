
IOENGINES=sync
DIRECT="0"
SEQ=0
RWMIX="0 50 100"
BSS="4k"
FILESIZE="25M"
JOBS="20"
IODEPTH="32 64"
RW="randrw"
MOUNTS=18
MOUNTPOINTS="/mnt/efs"

echo "sep=;" > fio.csv

for bss in $BSS; do
for filesize in $FILESIZE; do
for direct in $DIRECT; do
for ioengine in $IOENGINES; do
	for job in $JOBS; do
		for mix in $RWMIX; do
			for iodepth in $IODEPTH; do
			#fio --ioengine=$ioengine --direct=$direct --thread --group_reporting --rw=$RW --rwmixread=$mix --runtime=30 --bs=$bss --name=test1 --directory=/mnt/efs/ --numjobs=$job --iodepth=512 --size=$filesize --time_based --output fio.log --minimal	
			#sed -i "5s/.*/direct=$direct/" /home/iguazio/fio.conf
			#sed -i "6s/.*/bs=$bss/" /home/iguazio/fio.conf
			#sed -i "7s/.*/size=$filesize/" /home/iguazio/fio.conf
			#sed -i "9s/.*/numjobs=$job/" /home/iguazio/fio.conf
			#sed -i "12s/.*/rw=$RW/" /home/iguazio/fio.conf
			#sed -i "13s/.*/rwmixread=$mix/" /home/iguazio/fio.conf
			#
			#fio --output fio.log --minimal --client=/home/iguazio/fio_clients /home/iguazio/fio.conf # multi clients
			fio --time_based --output fio.log --minimal --ioengine=$ioengine --direct=$DIRECT --thread --group_reporting --rw=$RW --rwmixread=$mix --runtime=30 --bs=4096 --name=test1 --directory=/tmp/fuse_mount/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test2 --directory=/tmp/fuse_mount0/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test3 --directory=/tmp/fuse_mount1/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test4 --directory=/tmp/fuse_mount2/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test5 --directory=/tmp/fuse_mount3/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test6 --directory=/tmp/fuse_mount4/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test7 --directory=/tmp/fuse_mount5/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test8 --directory=/tmp/fuse_mount6/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test9 --directory=/tmp/fuse_mount7/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test10 --directory=/tmp/fuse_mount8/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test11 --directory=/tmp/fuse_mount9/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test12 --directory=/tmp/fuse_mount10/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test13 --directory=/tmp/fuse_mount11/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test14 --directory=/tmp/fuse_mount12/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test15 --directory=/tmp/fuse_mount13/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test16 --directory=/tmp/fuse_mount14/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test17 --directory=/tmp/fuse_mount15/ --numjobs=$job --iodepth=$iodepth --size=25M --name=test18 --directory=/tmp/fuse_mount16/ --numjobs=$job --iodepth=$iodepth --size=25M
#			fio --time_based --output fio.log --minimal --ioengine=$ioengine --direct=$DIRECT --thread --group_reporting --rw=$RW --rwmixread=$mix --runtime=30 --bs=4096 --name=test1 --directory=/tmp/fuse_mount/ --numjobs=$job --iodepth=$iodepth --size=25M 
			echo -ne "$ioengine;$direct;$filesize;$bss;$RW;$mix;$iodepth;$job;$MOUNTS;" >> fio.csv
			echo -ne `cat fio.log` >> fio.csv
			# echo -ne `cat fio.log | grep "All"` >> fio.csv #multi clients
			echo "" >> fio.csv
		done
	done
done
done
done
done
done
