In This Task we need to do following 

We need to use terraform to do this. Create a module called private hosted zone, which accepts a input domain name.

Create a first VPC. (only vpc, no need of subnets, RT, NATGW, IGW)

Create a secondary VPC (only vpc, no need of subnets, RT, NATGW, IGW)

Create Private hosted zone for VPC1. (use input hosted zone)

Associate Private hosted zone with VPC2.

Delete VPC1 after private hosted zone is connected with VPC2. (This may require customization)
