# ========================================
#  VPC CONFIGURATION
# ========================================
aws_region                = "us-east-1"
availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
vertical                  = "latam"
vpc_cidr                  = "10.96.0.0/21"
private_subnets           = ["10.96.0.0/24", "10.96.2.0/24", "10.96.4.0/24"]
attach_to_transit_gateway = true
transit_gateway_id        = "tgw-0e6c1db495f9ac32f"
environment               = "noprod"
private_routes = [
  {
    destination_cidr_block = "0.0.0.0/0"
    transit_gateway_id     = "tgw-0e6c1db495f9ac32f"
  }
]

project_tags = {
  Project     = "Latam"
  Environment = "noprod"
  Team        = "Networking"
  ManagedBy   = "Terraform"
}