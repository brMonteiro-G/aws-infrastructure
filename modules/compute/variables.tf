variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-05576a079321f21f8"  # Replace with your desired AMI ID
}

variable "volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 8
}