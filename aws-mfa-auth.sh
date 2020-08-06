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
# Script allows you to authenticate aws cli using MFA token and assume role,
# where Condition is to be authenticated by MFA
# Scipts adds 2 profiles to the end of ~/.aws/credentials file.
# Once you finish your session, please delete those entries in ~/.aws/credentials
# version 0.1
# TODO Error handling

echo -n "Enter profile name you want to use:  "
read profile  #which profile you want to use from ~/.aws/credentials
echo "Enter Temp profile name to be used to validate MFA authentication against assuming role. Recomended name -  temp$profile:  "
read tempprofile  #temp profile to be able to assume role with MFA to be written to ~/.aws/credentials
echo -n "Enter role arn. It is --role-arn in aws sts assume-role command:  "
read rolearn   #role arn to be assumed
echo "Enter desired Role Session Name. It is --role-session-name in aws sts assume-role command: "
read rolesessionname #role session name
echo "Enter Temp Role profile name. It will be used in any aws command as --profile profile-name:  "
read roleprofile #temp role profile to be written to
echo -n "Enter Your MFA arn: "
read mfa  #mfa arn
echo -n "Enter current MFA token: "
read token #current mfa tocken
aws sts get-session-token --serial-number $mfa --token-code $token --profile $profile >./mfa.tmp
echo "We've got session credentials. Now adding new profile $tempprofile to ~/.aws/credentials"
cat ./mfa.tmp
echo "-------------------------------"
echo [$tempprofile] >> ~/.aws/credentials
echo `cat ./mfa.tmp |grep AccessKeyId| sed 's/"//g'|sed 's/,//'|sed 's/:/=/'|sed 's/AccessKeyId/aws_access_key_id/'`>>~/.aws/credentials
echo `cat ./mfa.tmp |grep SecretAccessKey|sed 's/"//g'|sed 's/,//'|sed 's/:/=/'|sed 's/SecretAccessKey/aws_secret_access_key/'`>> ~/.aws/credentials
echo `cat ./mfa.tmp |grep SessionToken|sed 's/"//g'|sed 's/,//'|sed 's/:/=/'|sed 's/SessionToken/aws_session_token/'`>>~/.aws/credentials
echo "Added new profile $tempprofile"
echo "-------------------------------"
echo "Getting role $rolearn session credentials"
aws sts assume-role --role-arn $rolearn --profile $tempprofile  --role-session-name $rolesessionname >./mfa.tmp
echo "We've got session credentials.Now adding new profile $roleprofile to ~/.aws/credentials"
cat ./mfa.tmp
echo "-------------------------------"
echo [$roleprofile] >> ~/.aws/credentials
echo `cat ./mfa.tmp |grep AccessKeyId| sed 's/"//g'|sed 's/,//'|sed 's/:/=/'|sed 's/AccessKeyId/aws_access_key_id/'`>>~/.aws/credentials
echo `cat ./mfa.tmp |grep SecretAccessKey|sed 's/"//g'|sed 's/,//'|sed 's/:/=/'|sed 's/SecretAccessKey/aws_secret_access_key/'`>> ~/.aws/credentials
echo `cat ./mfa.tmp |grep SessionToken|sed 's/"//g'|sed 's/,//'|sed 's/:/=/'|sed 's/SessionToken/aws_session_token/'`>>~/.aws/credentials
echo "Added new profile $roleprofile"
echo
echo "Now you can use aws cli with assumed role using --profile $roleprofile"
echo "Assumed role is `cat ./mfa.tmp |grep Arn`"
echo "Please do not forget to delete profiles once you complete your session"
rm -f ./mfa.tmp
