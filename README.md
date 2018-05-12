## Terraform

Create following files at this level (root of terraform)
* secret.auto.tfvars (put AWS_ACCESS_KEY = "your aws access key" AWS_SECRET_KEY = "your aws secret key)
* secret.tfvars (access_key = "your aws access key" secret_key ="your aws secret key")

In order to run:

* terraform init -backend-config=secret.tfvars
* terraform plan -out=ops.plan
* terraform apply "ops.plan"
