#/bin/bash
# -----section copyright-----
#Copyright VirtIOGroove 2020
# Feel free to distribute and modify script.
#Please keep original copyright and author
#
# Author John Gakhokidze
# Last update 08/10/2020
#-----end section copyright-----
#
# Scripts gets AWS trusted Adviser check results 
# 3 examples are provided
#
# version 0.1
# TODO Error handling

# Getting profile to use
echo "Please enter profile to be used: "
read profile
# Getting checkID for Low Utilization Amazon EC2 Instances
lowutilizedec2instancescheckid=(`aws support describe-trusted-advisor-checks --profile $profile --language en |grep -i '"id"\|"name"' |tr '\,\n' ' '|sed 's/"id"/\n"id"/
g'|grep "Low Utilization Amazon EC2 Instances"|awk -F'"' '{print $4}'`)
echo "Low Utilization Amazon EC2 Instances" checkID=$lowutilizedec2instancescheckid

#Getting checkID for Underutilized Amazon EBS Volumes
underutilizedebsvolumescheckid=(`aws support describe-trusted-advisor-checks --profile $profile --language en |grep -i '"id"\|"name"' |tr '\,\n' ' '|sed 's/"id"/\n"id"/
g'|grep "Underutilized Amazon EBS Volumes"|awk -F'"' '{print $4}'`)
echo "Underutilized Amazon EBS Volumes" checkID=$underutilizedebsvolumescheckid

#Getting checkId for Amazon RDS Idle DB Instances
rdsidledbinstancescheckid=(`aws support describe-trusted-advisor-checks --profile $profile --language en |grep -i '"id"\|"name"' |tr '\,\n' ' '|sed 's/"id"/\n"id"/g'|gr
ep "Amazon RDS Idle DB Instances"|awk -F'"' '{print $4}'`)
echo "Amazon RDS Idle DB Instances" checkID=$rdsidledbinstancescheckid

#Getting checkId for Underutilized Amazon Redshift Clusters
#underutilizedredshiftclusterscheckid= aws support describe-trusted-advisor-checks --profile latam-legacy --language en |grep -i '"id"\|"name"' |tr '\,\n' ' '|sed 's/"i
d"/\n"id"/g'|grep "Underutilized Amazon Redshift Clusters"|awk -F'"' '{print $4}'

# Creating csv file sceleton for "Low Utilization Amazon EC2 Instances"
echo "Creating csv file ~/$profile-LowUtilizationAmazonEC2Instances.csv  in home folder"
touch ~/$profile-LowUtilizationAmazonEC2Instances.csv
echo region,az,instanceId,instanceName,instanceType,MonthlySavings >  ~/$profile-LowUtilizationAmazonEC2Instances.csv

(aws support describe-trusted-advisor-check-result --check-id $lowutilizedec2instancescheckid --profile $profile --output json|(jq -r '.[].flaggedResources[]| .region a
s $a|([$a,.metadata[0,1,2,3,4]]|@csv)')|sed 's/\"//g') >> ~/$profile-LowUtilizationAmazonEC2Instances.csv


# Creating csv file sceleton for  "Underutilized Amazon EBS Volumes"
echo "Creating csv file ~/$profile-UnderUtilizedAmazonEBSVolumes.csv in home folder"
touch ~/$profile-UnderUtilizedAmazonEBSVolumes.csv
echo region,volumeID,volumeName,volumeType,volumeSize,MonthlySavings,snapshotID,SnapshotName,SnapshotAge >  ~/$profile-UnderUtilizedAmazonEBSVolumes.csv

(aws support describe-trusted-advisor-check-result --check-id $underutilizedebsvolumescheckid --profile $profile --output json|(jq -r '.[].flaggedResources[]| .region a
s $a|([$a,.metadata[1,2,3,4,5,6,7,8]]|@csv)')|sed 's/\"//g') >> ~/$profile-UnderUtilizedAmazonEBSVolumes.csv


# Creating csv file sceleton for  "Amazon RDS Idle DB Instances"
echo "Creating csv file ~/$profile-AmazonRDSIdleDBInstances.csv in home folder"
touch ~/$profile-AmazonRDSIdleDBInstances.csv
echo region,dbInstanceName,Multi-AZ,instanceType,StorageProvisioned%,days-sincelastconnection,MonthlySavings > ~/$profile-AmazonRDSIdleDBInstances.csv

(aws support describe-trusted-advisor-check-result --check-id $rdsidledbinstancescheckid --profile $profile --output json|(jq -r '.[].flaggedResources[]| .region as $a|
([$a,.metadata[1,2,3,4,5,6]]|@csv)')|sed 's/\"//g') >> ~/$profile-AmazonRDSIdleDBInstances.csv


# Creating csv file sceleton for  "Underutilized Amazon Redshift Clusters"
#echo "Creating csv file ~/$profile-UnderutilizedAmazonRedshiftClusters.csv in home folder"
#touch ~/$profile-UnderutilizedAmazonRedshiftClusters.csv
#echo region,volumeID,volumeName,volumeType,volumeSize,MonthlySavings,snapshotID,SnapshotName,SnapshotAge > ~/$profile-UnderutilizedAmazonRedshiftClusters.csv

#aws support describe-trusted-advisor-check-result --check-id $underutilizedredshiftclusterscheckid --profile $profile --output json|(jq -r '.[].flaggedResources[]| .re
gion as $a|([$a,.resourceId,.metadata[0,1,2,3,4,5,6,7,8]]|@csv)')|sed 's/\"//g') >> ~/$profile-UnderutilizedAmazonRedshiftClusters.csv


# Getting enabled regions from aws ec2 describe-regions
# Cleaning up output to region and scanning for EIPs without associated ENIs



# Final words, csv output is avaible at ~/$profile.csv
echo "CSV files are available at home folder"

ls -la ~/$profile-*.csv
