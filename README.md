# terraform-aws-ecs

This repository is a set of Terraform modules for configuring infrastructure with AWS, Docker, and ECS.

## Quickstart

The easiest way to get the modules and running is by creating a Terraform definition for it, copy this snippet in a file
named `main.tf`:

```hcl
module "ecs-cluster" {
  source = "git::https://github.com/tierratelematics/terraform-aws-ecs.git//modules/ecs-cluster?ref=0.1.0"


  environment = "${var.environment}"
  project     = "${var.project}"

  cluster_name                   = "main"
  instance_list_available_zone   = ["${var.aws["availability_zone"]}"]
  instance_list_public_subnet_id = ["${var.aws["public_1_subnet_id"]}", "${var.aws["public_2_subnet_id"]}"]
  instance                       = "${var.ecs_instance}"
  security_vpc_id                = "${var.aws["vpc_id"]}"
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