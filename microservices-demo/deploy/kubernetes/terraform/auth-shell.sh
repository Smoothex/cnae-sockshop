echo "Hi welcome to key setup shell for AWS "
echo "Please wait for the key env variable to be set up "


export AWS_ACCESS_KEY_ID=AKIAXXIGQFCTB4PFDTOL
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=eu-central-1

echo "environment variable finished setting up"

echo "generating credentials for aws E2C"
aws ec2 create-key-pair --key-name deploy-docs-k8s --query 'KeyMaterial' --output text > ~/.ssh/deploy-docs-k8s.pem

chmod 600 ~/.ssh/deploy-docs-k8s.pem
