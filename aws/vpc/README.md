# AWS VPC

Module for creating a VPC in AWS.

Resources:

* An AWS VPC with the given CIDR block
* An Internet gateway for access to the public Internet
* A NAT gateway for the Internet gateway with an allocated IPv4 IP address
* Public and private subnets for each given availability zone
* Route tables for public and private traffic

Outputs:

* The VPC
* The public and private subnets
* The default security group for the given VPC
