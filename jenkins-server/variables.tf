variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "pb_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "instance_type" {
  description = "EC2 instance type for the Jenkins server"
  type        = string
}