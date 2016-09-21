#!/bin/bash
function hmac_sha256 {
  key="$1"
  data="$2"
  echo -n "$data" | openssl dgst -sha256 -mac HMAC -macopt "$key" | sed 's/^.* //'
}

secret="$1"
date="$2"
region="$3"
service="$4"

# Four-step signing key calculation
dateKey=$(hmac_sha256 key:"AWS4$secret" $date)
dateRegionKey=$(hmac_sha256 hexkey:$dateKey $region)
dateRegionServiceKey=$(hmac_sha256 hexkey:$dateRegionKey $service)
signingKey=$(hmac_sha256 hexkey:$dateRegionServiceKey "aws4_request")

echo $signingKey
