#!/bin/bash
COUNTRY=$@
while read p; do
echo ${p}
COUNTRYNAME=$(cat IP2LOC.CSV| grep -e "${p}" | cut -f4 -d','|sort -u)
echo ${COUNTRYNAME}
./CountryToIpRange.sh "${p}"
./converttosubnets.sh "${p}"
done <list
