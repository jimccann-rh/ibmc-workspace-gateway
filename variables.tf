variable "iaas_classic_api_key" {
  description = "The API key for the IBM Cloud Classic infrastructure service."
  type        = string
  sensitive = true
}

variable "iaas_classic_username" {
  description = "The username for the IBM Cloud Classic infrastructure service."
  type        = string
  sensitive = true
}

variable "datacenter" {
  description = "The datacenter in which to provision compute."
  type        = string
}

variable "project" {
  description = "Prefix to add to all resources for easier identification."
  type        = string
}

variable "domain_name" {
  description = "The domain name to use for all resources."
  type        = string
  default     = "example.com"
}

variable "gateway_private_vlan" {
  description = "Private VLAN of VSI systems"
  type        = string
  default     = ""
}

variable "gateway_public_vlan" {
  description = "Public VLAN of VSI systems"
  type        = string
  default     = ""
}
