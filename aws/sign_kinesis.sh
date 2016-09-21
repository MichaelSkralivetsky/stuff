payload=$1
if [ -z $payload ]; then 
	echo "./sign.sh <payload json>"
	exit 1
fi
AKI=  # Amazon access key ID
SAK=  # Amazon secret access key
base_date=`date -u +"%Y%m%d"`
full_date=`date -u +"%Y%m%dT%H%M%SZ"`

payload_hash=`cat $1 | openssl dgst -sha256 | sed 's/^.* //'`
sed -i "10s/.*/$payload_hash/" can_req
key=`./signing_key.sh qINLznTAqRm8cTVT2T3DPHMuKFbqrg66aVAlBB5v $base_date us-west-2 kinesis`
sed -i "s/x-amz-date:[0-9].*/x-amz-date:$full_date/g" can_req
canonical_hash=`head -c -1 can_req | openssl dgst -sha256 | sed 's/^.* //'`
sed -i "2s/.*/$full_date/" string
sed -i "3s/[0-9]*/$base_date/" string
sed -i "4s/.*/$canonical_hash/" string
signature=`head -c -1 string | openssl dgst -sha256 -mac HMAC -macopt hexkey:$key | sed 's/^.* //'`
echo $signature $base_date $full_date
