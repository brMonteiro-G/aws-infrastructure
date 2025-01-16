module "network"{
    source = "../network"
}

# Security Group for EC2
resource "aws_security_group" "private-sec-group" {
  name_prefix = "private-sec-group"
  description = "Allow inbound traffic for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

   ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    security_groups = [aws_security_group.management-sec-group.id]
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

resource "aws_security_group" "management-sec-group" {
  name_prefix = "management-sec-group"
  description = "Allow inbound traffic for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    security_groups = [aws_security_group.public-sec-group.id]
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

resource "aws_security_group" "public-sec-group" {
  name_prefix = "public-sec-group"
  description = "Allow inbound traffic for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}



# Reference for rules from other security groups
resource "aws_security_group_rule" "ssh_from_mgmt_box" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.public-sec-group.id
  description = "SSH from mgmt-box"
}

resource "aws_security_group_rule" "all_tcp_from_mgmt_box" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.public-sec-group.id
  description = "All TCP from 10.0.0.0/16"
}

resource "aws_security_group_rule" "ssh_from_my_ip" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["187.56.118.253/32"]
  security_group_id = aws_security_group.public-sec-group.id
  description = "SSH from my IP"
}

resource "aws_security_group_rule" "icmp_from_mgmt_box" {
  type        = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.public-sec-group.id
  description = "Ping from mgmt-box"
}

resource "aws_security_group_rule" "https_public_access" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public-sec-group.id
  description = "HTTPS public subnet access"
}




resource "aws_security_group_rule" "ssh_from_my_ip_management" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["191.254.133.3/32"]  # Specific IP for SSH access
  security_group_id = aws_security_group.management-sec-group.id
  description = "SSH from my IP to management subnet"
}


resource "aws_security_group_rule" "icmp_from_source_sg" {
  type                   = "ingress"
  from_port              = -1  # All ICMP types
  to_port                = -1  # All ICMP types
  protocol               = "icmp"
  security_group_id      = aws_security_group.private-sec-group.id
  source_security_group_id = aws_security_group.private-sec-group.id  # Allow ICMP from source security group
  description            = "Test connection from source security group"
}



# EC2 Instance
resource "aws_instance" "jump-server" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.management-sec-group.id]
  subnet_id = module.network.public_subnet_ids[0]

  # EC2 Tags
  tags = {
    Name = "Example-EC2-Instance"
  }

  # Attach EBS Volume
  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  # Optionally, associate an Elastic IP with the instance (if required)
  # associate_public_ip_address = true
}

# EC2 Instance
resource "aws_instance" "web-server" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.public-sec-group.id]
  subnet_id = module.network.public_subnet_ids[0]

  # EC2 Tags
  tags = {
    Name = "Example-EC2-Instance"
  }

  # Attach EBS Volume
  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  # Optionally, associate an Elastic IP with the instance (if required)
  # associate_public_ip_address = true
}

# EC2 Instance
resource "aws_instance" "database-server" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.private-sec-group.id]
  subnet_id = module.network.private_subnet_ids[0]

  # EC2 Tags
  tags = {
    Name = "Example-EC2-Instance"
  }

  # Attach EBS Volume
  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  # Optionally, associate an Elastic IP with the instance (if required)
  # associate_public_ip_address = true
}

# EBS Volume (Optional - If you'd like to create a separate volume)
resource "aws_ebs_volume" "example_volume" {
  availability_zone = "us-east-1a"
  size              = var.volume_size
  type              = "gp2"
  tags = {
    Name = "Example-Volume"
  }
}

# Attach EBS Volume to EC2
resource "aws_volume_attachment" "example_attachment" {
  device_name = "/dev/sdf"  # Name used in the EC2 instance (Linux)
  volume_id   = aws_ebs_volume.example_volume.id
  instance_id = aws_instance.jump-server.id
}
