In This Task 

Write Terraform Module to build a pipeline on AWS as below.
We should be able to call this module in case we need to create 10 or 100 different pipeline for terraform.
Expected end date : 7th may




Source:-
trigger pipeline on commit or merge
Build :-
terraform init
tflint --init
tflint
terraform-docs markdown table .
terraform validate
terraform fmt .
Plan :-
terraform plan



Manual approval :-> sns email notification for approval waiting



Deploy :-
teraform apply
