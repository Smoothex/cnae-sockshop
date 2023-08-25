# Cloud deployment

The target cloud service for the project is Amazon web services (AWS). Free tier version of the AWS will be used.

For more information regarding AWS free Tier please visit the official [AWS](https://aws.amazon.com/free/?trk=9ab5159b-247d-4917-a0ec-ec01d1af6bf9&sc_channel=ps&ef_id=Cj0KCQjw3JanBhCPARIsAJpXTx49nE-theu3kcDhXL58JSGzydOlVk2ec4gIN1oLs_KheA-fq1ypJ-EaAnLhEALw_wcB:G:s&s_kwcid=AL!4422!3!645133561110!e!!g!!aws%20free%20tier!19579657595!152087369744&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=tier%23trial&awsf.Free%20Tier%20Categories=*all) website

Terraform  will be used to setup the infrastructure on AWS. 

Please follow the steps to setup the infrastructure on AWS

## pre-requisites

The code was tested on Apple mac m2 chip. Install the required tools

- Terraform version : v1.5.5
- Create a [AWS account](https://aws.amazon.com/free/?trk=9ab5159b-247d-4917-a0ec-ec01d1af6bf9&sc_channel=ps&ef_id=Cj0KCQjw3JanBhCPARIsAJpXTx6T2xTJSUJdbZA1wlIEkPJS9kMGf-x7I__vUREZ3ME1buKTAkSg0GgaApRYEALw_wcB:G:s&s_kwcid=AL!4422!3!645133561110!e!!g!!create%20aws%20account!19579657595!152087369744&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all)
- awscli version : 2.13.9

To check the pre installed version of the tools 

For terraform execute the command in terminal : `terraform version`

![Screenshot 2023-08-23 at 17.05.37.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-23_at_17.05.37.png)

For awscli execute : `aws --version`

![Screenshot 2023-08-23 at 17.06.44.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-23_at_17.06.44.png)

Sock shop itself provides the documentation for AWS deployment but has been already outdated as most of the underlying infrastructure has changed and the old terraform files require new security parameters to be included. Furthermore deploying the sock shop web application, requires necessary packages to be pre installed in order to run kubernetes application. The installation process of necessary packages has too changed. Hence a new terraform installation file is available under */cnae-sockshop/microservices-demo/deploy/kubernetes/AWS deployment/*

We have a combination of Terraform and shell scripts to automate the whole process for setting up the infrastructure and deploy sock shop smoothly.

<aside>
💡 Note : As mentioned earlier we will be working with the free tier of AWS. Hence we don’t have access to [EKS,](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) which is a managed kubernetes service by AWS and it saves a load of hazzle for the developer in order to deploy the application.

We will be working with t2.micro EC2 instances of ubuntu having 1vCPU and with 1GB of memory.

![Screenshot 2023-08-23 at 17.24.33.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-23_at_17.24.33.png)

</aside>

## Step-by-step guide

- Creating [access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) on AWS
    
    login to your AWS account 
    
    1. In the navigation bar on the upper right, choose your user name, and then choose **Security credentials**.
        
        ![https://docs.aws.amazon.com/images/IAM/latest/UserGuide/images/security-credentials-user.shared.console.png](https://docs.aws.amazon.com/images/IAM/latest/UserGuide/images/security-credentials-user.shared.console.png)
        
    
    Follow the steps :[source : [AWS official website](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)]
    
    1. In the **Access keys** section, choose **Create access key**. If you already have two access keys, this button is deactivated and you must delete an access key before you can create a new one.
    2. On the **Access key best practices & alternatives** page, choose your use case to learn about additional options which can help you avoid creating a long-term access key. If you determine that your use case still requires an access key, choose **Other** and then choose **Next**.
    
    <aside>
    💡 Copy the access key and secret key on clipboard to be used later to generate key value pair.
    
    </aside>
    
    1. (Optional) Set a description tag value for the access key. This adds a tag key-value pair to your IAM user. This can help you identify and rotate access keys later. The tag key is set to the access key id. The tag value is set to the access key description that you specify. When you are finished, choose **Create access key**.
    2. On the **Retrieve access keys** page, choose either **Show** to reveal the value of your user's secret access key, or **Download .csv file**. This is your only opportunity to save your secret access key. After you've saved your secret access key in a secure location, choose **Done**.
- Generating key value pair
    
    We will start by exporting some envirnomental variables on the local system and not save them in a file due to security reasons. As your free tier resources can be used by some free loaders and get your account suspended. 
    
    Next execute the command :
    
    ```bash
    aws configure
    ```
    
    ![Design ohne Titel.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Design_ohne_Titel.png)
    
    Your default region can be seen on top right corner . For the usage in germany Frankfurt is the region to go, which is “eu-central-1”
    
    ![Screenshot 2023-08-23 at 18.11.10.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-23_at_18.11.10.png)
    
    Once setup of the variable is finished run the following commands  to generate key value pair and store in the folder *~/.ssh/ .* Next change the file permission which allows the owner of the file to have read and write permission.
    
    ```bash
    aws ec2 create-key-pair --key-name deploy-docs-k8s --query 'KeyMaterial' --output text > ~/.ssh/deploy-docs-k8s.pem
    
    chmod 600 ~/.ssh/deploy-docs-k8s.pem
    ```
    
    Furthermore add the following environmental variable for terraform. Simply execute in the terminal window. 
    
    ```bash
    export TF_VAR_access_key=AKI*********Z***A
    export TF_VAR_secret_key=CVZ**********************9
    ```
    
- Create infrastructure on AWS
    
    Navigate to the */cnae-sockshop/microservices-demo/deploy/kubernetes/AWS\ deployment* 
    
    Execute the following commands:
    
    ```bash
    terraform init
    
    terraform plan 
    
    terraform apply
    ```
    
    ![Screenshot 2023-08-24 at 01.17.26.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-24_at_01.17.26.png)
    
    AWS instances will be created and will be seen in the aws console. From the above masterIP is available to us 
    
    ### Master node configuration :
    
    Now ssh into your master node using terminal :
    
    ## for master_public_ip use the IP adress from the above
    
    ```bash
    ssh -i ~/.ssh/deploy-docs-k8s.pem ubuntu@<master_public_ip>
    ```
    
    Master public ip can be seen either from terminal itself in the outputs of the terraform or from the AWS console 
    
    ## add image for AWS console
    
    now as you are in the master instance console. Make sure kubeadm is installed by using `kubeadm verison` 
    
    Execute the following comand to setup configuration for kubernetes master node :
    
    ```bash
    chmod +x /tmp/master_setup.sh && /tmp/master_setup.sh
    ```
    
    once executed the result will be as follows
    
    ![Screenshot 2023-08-24 at 01.26.36.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-24_at_01.26.36.png)
    
    copy the last two lines as marked as it will be used to connect worker node to the master in order to form a k8s cluster.
    
    In order to check the status of kubernetes master node : 
    
    ```bash
    kubectl get nodes
    ```
    
    ![Screenshot 2023-08-24 at 01.30.20.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-24_at_01.30.20.png)
    
    It should show the status ready which means the weavenet cli plugin is successfully installed and is up and running. 
    
    Next we will be joining the worker/slave nodes to our master node 
    
    ![Screenshot 2023-08-24 at 12.41.32.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-24_at_12.41.32.png)
    
    ```bash
    ssh -i ~/.ssh/deploy-docs-k8s.pem ubuntu@<worker_public_ip> # Here the
     # above node-addresses can be used to ssh into the instance. This are dns names of all the worker instance 
    ```
    
    and execute the kubeadm join command which was copied from before and run with sudo and one more flag `--ignore-preflight-errors=all.` As we don’t have enough resources required by kubernetes officially to run nodes. Do the following for all the worker nodes.
    
    ```bash
    sudo kubeadm join <ip address> --token <token> --discovery-token-ca-cert-hash <hash token> --ignore-preflight-errors=all
    ```
    
    ![Screenshot 2023-08-24 at 12.50.15.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-24_at_12.50.15.png)
    
    Now to check if the worker are connected to master ssh into your master instance 
    
    and execute 
    
    ```bash
    kubectl get nodes
    ```
    
    ![Screenshot 2023-08-24 at 12.54.43.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-24_at_12.54.43.png)
    
    One can see different nodes connected and the status should be ready if not then delete the particular instance and generate one more. Otherwise restart the whole process.
    
- Deployment
    
    Now we are all setup with our k8s cluster. To deploy the sock shop 
    
    ssh into your master node and execute the following in the shell
    
    ```bash
    chmod +x /tmp/deploy_sockshop.sh && /tmp/deploy_sockshop.sh
    ```
    
    ![Screenshot 2023-08-24 at 13.00.58.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-24_at_13.00.58.png)
    
    Some similar information can be seen. It might take a while to set it up and running as some workarounds have been added to deploy the application due to less resources available in free tier of AWS. 
    
    At the end execute `kubectl get nodes` to check if all the nodes are still working and haven’t overloaded or closed due to some errors. 
    
    Next execute `kubectl get pods -A` to see if all the pods are up and running 
    
    ![Screenshot 2023-08-25 at 10.18.50.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-25_at_10.18.50.png)
    
    Name space can be easily changed to see `kubectl get pods -n sock-shop` to see all the pods running in the namepsace sock-shop
    
    ![NOTE: it might take a bit of time till all pods are running.](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-25_at_10.20.59.png)
    
    NOTE: it might take a bit of time till all pods are running.
    
    Once all are up and running, lets see the hosted sock-shop application. Execute
    
    ```bash
     kubectl describe svc front-end -n sock-shop
    ```
    
    ![Screenshot 2023-08-24 at 13.13.47.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-24_at_13.13.47.png)
    
    The website is hosted at http://<master_node_public_ip>:<NodePort>
    
    In our case it is http://18.193.110.84:30001
    
    ![Screenshot 2023-08-24 at 23.33.51.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-24_at_23.33.51.png)
    
- Deployment with new solution HPA+autoscaling
    
    navigate to the folder : */cnae-sockshop/microservices-demo/deploy/kubernetes/AWS_optimized_deployment*
    
    Follow the same steps as in the above section [create infrastructure](https://www.notion.so/Cloud-deployment-81a84cafef4c440ebca34b823d4d9383?pvs=21) and  [Deployment](https://www.notion.so/Cloud-deployment-81a84cafef4c440ebca34b823d4d9383?pvs=21)
    
    ![Screenshot 2023-08-25 at 20.05.50.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-25_at_20.05.50.png)
    
    Check that all the pods are up and running. It might take around 12-15 minutes to run on t2.micro instances. As suggested if possible use t2.medium
    
    ![Screenshot 2023-08-25 at 20.06.06.png](Cloud%20deployment%2081a84cafef4c440ebca34b823d4d9383/Screenshot_2023-08-25_at_20.06.06.png)