#!/bin/bash
#
COUNTRY=$@
set -u
OUPUT_DIRECTORY='IpPerCountry'

#function RECORD the status NAME
function export_result_xlet_to_sql(){
ip1=$1
ip2=$2
ip3=$3
ip4=$4
#echo "INSERT INTO ip_info (ip1, ip2,ip3, ip4, Country, Region, RegionCode, City, ZipCode, Latitude, Longitude, ISP, ORG, ASN, Timezone) VALUES ('${ip1}', '${ip2}', '${ip3}', '${ip4}', , , , , '', '', '', '', '', '', '' );"
echo "INSERT INTO ip_info (ip1, ip2,ip3, ip4, Country, Region, RegionCode, City, ZipCode, Latitude, Longitude, ISP, ORG, ASN, Timezone) VALUES ('${ip1}', '${ip2}', '${ip3}', '${ip4}','', '', 0, '', 0, 0,0, '', '', '', 0);"|mysql -D ip_db -h localhost -u root -pazerty123

}

dec2ip () {

dec=$1
ip=''
for e in {3..0}
do
((octet = dec / (256 ** e) ))
((dec -= octet * 256 ** e))
ip+=${octet}.

done
printf '%s\n' "$ip"
}
rm -f "${OUPUT_DIRECTORY}/${COUNTRY}.csv" "${OUPUT_DIRECTORY}/${COUNTRY}_iprange.csv"

#List Countries
mkdir -p ${OUPUT_DIRECTORY}
cat IP2LOC.CSV|grep -e "$COUNTRY" | cut -d',' -f1,2 >>"${OUPUT_DIRECTORY}/${COUNTRY}.csv"
#convert from big int to ip
while read raw_line; do
ip_dec=$(printf ${raw_line}|cut -f1 -d','|sed 's/"//g')
ip_s=$(dec2ip ${ip_dec})
ip_dec=$(printf ${raw_line}|cut -f2 -d','|sed 's/"//g')
ip_f=$(dec2ip ${ip_dec})
echo "${ip_s},${ip_f}'"|sed "s/.,/,/g"|sed "s/.'//g">>"${OUPUT_DIRECTORY}/${COUNTRY}_iprange.csv"
done < "${OUPUT_DIRECTORY}/${COUNTRY}.csv"
rm -f "${OUPUT_DIRECTORY}/${COUNTRY}.csv"



