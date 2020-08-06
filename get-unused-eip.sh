
for n in $(aws ec2 describe-regions --profile latam-legacy --region us-east-1|grep RegionName|awk -F ':' '{print $2}' |sed 's/[",]//g'|grep us-east-1);do (echo $n':,-,-,-' &&  aws ec2 describe-addresses --profile latam-legacy  --region $n --output text && echo '' )|grep -v TAGS|grep -v eni|sed 's/\s\+/,/g'|sed 's/ADDRESSES,//';done
