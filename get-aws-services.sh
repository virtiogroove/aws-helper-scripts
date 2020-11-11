#There was interesting question in AWS Builders community, how to get all AWS services list in IAM format. 
#There are many Github repositories, which maintain static list, but I wanted something dynamic. 
#Investigating code for AWS services page https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/
#I was thinking it is indeed JSON list of services, constantly updating. 
#Here is link to page https://api.regional-table.region-services.aws.a2z.com/index.json
#Parsing file:
#Note: I assume we downloaded file and saved to services.json
#All services in all regions, including People's Republic of China:

cat services.json |jq -r '.prices[]|.id as $d|([$d]|@csv)'

#Particular service FSX Lustre:
cat services.json |jq -r '.prices[]|.id as $d|([$d]|@csv)' |grep lustre

#If you want to print with service full name - not elegant but works:

cat services.json |jq -r '.prices[]|.id as $d|([.attributes|tostring ,$d]|@csv)'|awk -F ',' '{print $2, $4}'
