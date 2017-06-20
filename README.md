# terraform-aws-ecs

This repository is a set of Terraform modules for configuring infrastructure with AWS, Docker, and ECS.

## Quickstart

The easiest way to get the modules and running is by creating a Terraform definition for it, copy this snippet in a file
named `main.tf`.

### Simple

```hcl
module "ecs-cluster" {
  source = "git::https://github.com/tierratelematics/terraform-aws-ecs.git//modules/ecs-cluster?ref=0.4.0"
 
  project     = "${var.project}"
  environment = "${var.environment}"
 
  cluster_name                   = "main"
  instance_list_available_zone   = ["${var.aws["availability_zone_1"]}", "${var.aws["availability_zone_2"]}"]
  instance_list_public_subnet_id = ["${var.aws["public_1_subnet_id"]}", "${var.aws["public_2_subnet_id"]}"]
  instance                       = "${var.ecs_instance}"
  security_vpc_id                = "${var.aws["vpc_id"]}"
}
```

### Internal DNS record (optional)

You can optionally register an internal DNS name on a Private Hosted Zone.

```hcl
module "ecs-cluster" {
  source = "git::https://github.com/tierratelematics/terraform-aws-ecs.git//modules/ecs-cluster?ref=0.4.0"
 
  [...]
  
  internal_dns_name = "dev.app.local"
  internal_zone_id  = "Zxxxxxxx"
  
}
```

If you specify an `internal_dns_name` the module will create an `A` record for each private IP address in the EC2 
instance. Check the module source for the current naming convention for the DNS record. 

### Parameters

The `aws` module parameter contains the AWS related information.
 
 ```hcl
aws = {
  region              = "eu-west-1"

  availability_zone_1 = "eu-west-1a"
  availability_zone_2 = "eu-west-1c"

  vpc_id              = "vpc-xxxxxxxx"

  public_1_subnet_id  = "subnet-xxxxxxxx"
  public_2_subnet_id  = "subnet-xxxxxxxx"
  
  ...
}
```

The `instance` module parameter should provide the required information to create a EC2 instance to run the containers. 
See the following snipplet from a `terraform.tfvars` file: 

```hcl
ecs_instance = {
  key_name = "my-key-pair-name"
  type     = "t2.small"
  ami      = "latest"
  profile  = "my-server-profile"
}
```



## License

Copyright 2017 Tierra SpA

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.