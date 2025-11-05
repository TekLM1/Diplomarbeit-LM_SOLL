module "DA-LM-TEST-TF" {
  source = ""

  customer_name   = "Diplomarbeit-LM"
  ec2_function    = "Test"
  customer_prefix = "DA_LM"

  #Set EC2 AMI and Type
  ec2_ami  = "ami-0a5237fe4793e04b1"
  ec2_type = "t3.micro"

  #Set EBS Volume Size and Type
  ebs_volume_type = "gp2"
  ebs_volume_size = "50"

  # Set EC2 Access Key and VPC ID and Subnet ID
  ec2_key       = ""
  ec2_vpc_id    = ""
  ec2_subnet_id = ""

  # Set Elastic IP Allocation ID for the used EIP
  eip_allocation_id = ""

  # Set Ingress Rules
  ingress_rules = [
    {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["1.1.1.1/32"]
      description = "SSH - Fogbyte Access"
    },
    {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH - all"
    }

  ]

  egress_rules = [
    {
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]

}

