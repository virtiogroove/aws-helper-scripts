#/bin/bash
# -----section copyright-----
#Copyright VirtIOGroove 2020
# Feel free to distribute and modify script.
#Please keep original copyright and author
#
# Author John Gakhokidze
# Last update 08/05/2020
#-----end section copyright-----
#
# Script allows you get tags from any supported resource tag
# version 0.1
# TODO Error handling
#Profile to use
echo Please enter profile to use
read profile

#Region to scan
echo Please enter region to scan
read region

#Resourcs type
echo What resource type you want to scan for tags
echo Please enter one of the following
echo customer-gateway \| dedicated-host \| dhcp-options \| elastic-ip \| fleet \| fpga-image \| host-reservation \| image \| instance \| internet-gateway \| key-pair \| launch-template \| natgateway \| network-acl \| network-interface \| placement-group \| reserved-instances \| route-table \| security-group \| snapshot \| spot-instances-request \| subnet \| volume \| vpc \| vpc-endpoint \| vpc-endpoint-service \| vpc-peering-connection \| vpn-connection \| vpn-gateway
read resourceid

#Getting resources
echo Gettign Resources RecourceType=$resourceid
aws ec2 describe-tags --filters "Name=resource-type,Values=$resourceid" | jq -r '.Tags[]| .ResourceId as $d|([$d]|@csv)'|sed 's/\"//g' >resources.txt

#Getting particular resource-type tags
for n in $(cat resources.txt);do (aws ec2 describe-tags --filters "Name=resource-id,Values=$n" --profile $profile --region $region && echo -n $n: >>$region-tags.csv) |jq -r  '.Tags[]|.Key as $k|([$k,.Value]|@csv)'|sed ':a;N;$!ba;s/\n/:/g' >>$region-tags.csv;done

#Cleanup csv
sed -i 's/:"/;"/g' $region-tags.csv
