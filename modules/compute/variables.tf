variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI ID
}

variable "volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 8
}