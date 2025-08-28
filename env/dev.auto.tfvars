# ========================================
# VPC CONFIGURATION
# ========================================
aws_region                = "us-east-1"
availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
vertical                  = "latamweb"
vpc_cidr                  = "10.96.8.0/21"
private_subnets           = ["10.96.8.0/24", "10.96.10.0/24", "10.96.12.0/24"]
attach_to_transit_gateway = true
transit_gateway_id        = "tgw-0e6c1db495f9ac32f"
environment               = "dev"
private_routes = [
  {
    destination_cidr_block = "0.0.0.0/0"
    transit_gateway_id     = "tgw-0e6c1db495f9ac32f"
  }
 ]

vpc_id_associate = null
resolver_rule_id = null

project_tags = {
  Project     = "Latamweb"
  Environment = "dev"
  Team        = "Networking"
  ManagedBy   = "Terraform"
}