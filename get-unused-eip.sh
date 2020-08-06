#/bin/bash
# -----section copyright-----
#Copyright VirtIOGroove 2020
# Feel free to distribute and modify script.
#Please keep original copyright and author
#
# Author John Gakhokidze
# Last update 08/06/2020
#-----end section copyright-----
#
# Scripts gets enabled regions from aws ec2 describe-regions output
# and puts unused EIPs in csv file per region
#
# version 0.1
# TODO Error handling

# Getting profile to use
echo "Please enter profile to be used: "
read profile

# Creating csv file sceleton
echo "Creating csv file $profile.csv in nome folder"
touch ~./$profile.csv
echo eipallocation-id,scope,ip-address,provider >  ~./$profile.csv

# Getting enabled regions from aws ec2 describe-regions
# Cleaning up output to region and scanning for EIPs without associated ENIs

for n in $(aws ec2 describe-regions --profile $profile --region us-east-1|grep RegionName|awk -F ':' '{print $2}' \
  |sed 's/[",]//g');do (echo $n':,-,-,-' &&  aws ec2 describe-addresses --profile latam-legacy  --region $n --output text && echo '' )\
  |grep -v TAGS|grep -v eni|sed 's/\s\+/,/g'|sed 's/ADDRESSES,//' >>  ~./$profile.csv;done
  
# Final words, csv output is avaible at ~./$profile.csv
echo "CSV file is available at ~./$profile.csv"
