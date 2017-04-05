#!/bin/bash
COUNTRY=$@
INPUT_DIRECTORY='IpPerCountry'
OUTPUT_DIRECTORY='IpPerCountrySubnetted'
mkdir -p ${OUTPUT_DIRECTORY}
calculatesubnet(){
ip1=$1
ip2=$2

ip1_1=$(echo $ip1|cut -f1 -d'.')
ip1_2=$(echo $ip1|cut -f2 -d'.')
ip1_3=$(echo $ip1|cut -f3 -d'.')
ip1_4=$(echo $ip1|cut -f4 -d'.')

ip2_1=$(echo $ip2|cut -f1 -d'.')
ip2_2=$(echo $ip2|cut -f2 -d'.')
ip2_3=$(echo $ip2|cut -f3 -d'.')
ip2_4=$(echo $ip2|cut -f4 -d'.')
dec1=$((${ip1_1} * 256 ** 3 + ${ip1_2} * 256 ** 2 + ${ip1_3} * 256 + ${ip1_4}))
dec2=$((${ip2_1} * 256 ** 3 + ${ip2_2} * 256 ** 2 + ${ip2_3} * 256 + ${ip2_4}))
range=$((${dec2} - ${dec1}))
mask=32
max_usable=4
for i in `seq 0 21`
do
max_usable=$((${max_usable}*2 ))
prefix=$((29 - $i ))
diff=$((${max_usable} - $range ))

if [ $diff -lt 0 ]
then
prefix_finale=${prefix}
prefix_finale=$((${prefix_finale} - 1 ))
fi

done
echo "${ip1_1}.${ip1_2}.${ip1_3}.${ip1_4}/${prefix_finale}">>"${OUTPUT_DIRECTORY}/${COUNTRY}.txt"
#printf '%d\n' "$((${ip1_1} * 256 ** 3 + ${ip1_2} * 256 ** 2 + ${ip1_3} * 256 + ${ip1_4}))"
}
rm -f ${OUTPUT_DIRECTORY}/${COUNTRY}_subnets.txt

while read ip_range; do
ip1=$(echo ${ip_range}|cut -f1 -d',')
ip2=$(echo ${ip_range}|cut -f2 -d',')
calculatesubnet $ip1 $ip2

done < "${INPUT_DIRECTORY}/${COUNTRY}_iprange.csv"





