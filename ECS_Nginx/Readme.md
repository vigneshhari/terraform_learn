This terraform project deploys a simple nginx application in AWS using ECS ( Elastic Container Service ). All prerequisites are automatically made by the terraform script including VPC's, Security Groups, IAM policies, ECS tasks, LB's, etc..   

This project uses local state with terraform, given its for demonstration. We can use remote state when working on complex projects with multiple contributors.  

To deploy this application, run the following command

```bash
terraform apply
```
The output of the apply command will provide the DNS hostname of the LB.  
  
To view changes made by this terraform script, run the following command

```bash
terraform plan
```


Note -  
This project was designed to run in AWS in the `us-east-1` region, changing regions might require changes in the AMI ID.
