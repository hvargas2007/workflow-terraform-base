# ========================================
#  VPC CONFIGURATION
# ========================================
aws_region                = "us-east-1"
availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
vertical                  = "latam"
vpc_cidr                  = "10.96.0.0/21"
private_subnets           = ["10.96.0.0/24", "10.96.2.0/24", "10.96.4.0/24"]
attach_to_transit_gateway = false
transit_gateway_id        = ""
environment               = "noprod"
private_routes = []

project_tags = {
  Project     = "Latam"
  Environment = "prod"
  Team        = "Networking"
  ManagedBy   = "Terraform"
}