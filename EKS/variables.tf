variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "pb_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "pv_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}
variable "instance_types" {
  description = "List of instance types for EKS node groups"
  type        = list(string)
}
