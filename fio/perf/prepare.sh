export LD_LIBRARY_PATH=/home/iguazio/igz/tools/engine/fio/lib:/home/iguazio/igz/tools/engine/accelio/lib:/home/iguazio/igz/clients/nginx/lib:/home/iguazio/igz/clients/v3io/lib
export SRV_ADDR0=10.10.3.13
/home/iguazio/igz/tools/engine/fio/bin/fio --server --daemonize=/tmp/fio.pid
