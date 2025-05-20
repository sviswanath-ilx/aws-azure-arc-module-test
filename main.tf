provider "aws" {
  profile = "sandbox" #var.profile_name  # AWS CLI profile name
  region = "us-east-2" #var.aws_region
}

locals {
  # Define local variables for the module
  # These variables can be used to customize the module's behavior
  # and can be overridden when calling the module.

  ArcForServerEC2SSMRoleName                  = "AzureArcForServerSSM"
  ArcForServerSSMInstanceProfileName          = "AzureArcForServerSSMInstanceProfile"
  EC2SSMIAMRoleAutoAssignment                 = "true"
  EC2SSMIAMRoleAutoAssignmentSchedule         = "Enable"
  EC2SSMIAMRoleAutoAssignmentScheduleInterval = "1 day"
  EC2SSMIAMRolePolicyUpdateAllowed            = "true"
  connector_primary_identifier                = "7d507318-43a0-4645-b97f-d4f331cdfb04"
  azure_client_id_uri                         = "api://34a6b290-8d65-48d3-966d-52758964f5e9"
  oidc_audience                               =  local.azure_client_id_uri
  oidc_subject                                = "c79e5535-7ea7-4197-8e0f-743faa585cd4"
  oidc_thumbprint                             = ["626d44e704d1ceabe3bf0d53397464ac8080142c"]
  oidc_url                                    = "https://sts.windows.net/975f013f-7f24-47e8-a7d3-abc4752bf346/"
  client_id_list                              = [local.azure_client_id_uri]
  
}

module "tags" {
  
  source           = "git::https://github.com/IntelexTechnologies/generic-tagging?ref=1.0.10"
  application      = "aws-azure-arc"
  business_owner   = "Intelex-CloudOps"
  application_role = "AWS Connector"
  criticality      = "Minor"
  data_sensitivity = "Low"
  environment      = "sandbox"
  technical_owner  = "Intelex-CloudOps"
}

module "azure_arc_aws" {

  source  = "git::https://github.com/sviswanath-ilx/aws-azure-arc-resources-test?ref=1.0.0"
  ArcForServerEC2SSMRoleName                  = local.ArcForServerEC2SSMRoleName
  ArcForServerSSMInstanceProfileName          = local.ArcForServerSSMInstanceProfileName
  EC2SSMIAMRoleAutoAssignment                 = local.EC2SSMIAMRoleAutoAssignment
  EC2SSMIAMRoleAutoAssignmentSchedule         = local.EC2SSMIAMRoleAutoAssignmentSchedule
  EC2SSMIAMRoleAutoAssignmentScheduleInterval = local.EC2SSMIAMRoleAutoAssignmentScheduleInterval
  EC2SSMIAMRolePolicyUpdateAllowed            = local.EC2SSMIAMRolePolicyUpdateAllowed
  connector_primary_identifier                = local.connector_primary_identifier
  oidc_audience                               = local.oidc_audience
  oidc_subject                                = local.oidc_subject
  oidc_thumbprint                             = local.oidc_thumbprint
  oidc_url                                    = local.oidc_url
  client_id_list                              = local.client_id_list
  tags                                        = module.tags.tags

}