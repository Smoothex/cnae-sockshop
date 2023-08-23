echo "Welcome to the automated setup of whole kubernetes on AWS with deployed  k8s"


terrform init 

terraform plan 
echo "sleeping for 5 seconds"
sleep 5
# brew install jq # only needed for first time on main local machine 

terraform apply -auto-approve


#  a new shell script will be executed after the infrastrcuture is setup 





