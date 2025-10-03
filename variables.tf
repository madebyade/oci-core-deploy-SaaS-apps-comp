# IAM groups (should already exist)
variable "secadmin_group_name" {
  type    = string
  default = "SECAdmins"
}

variable "iamadmin_group_name" {
  type    = string
  default = "IAMAdmins"
}

# Optional tags
#variable "defined_tags"  { type = map(map(string)), default = {} }
#variable "freeform_tags" { type = map(string), default = { "Environment" = "PROD" } }


# New OCI provider authentication variables
variable "tenancy_ocid" {
  description = "OCI tenancy OCID"
  type        = string
}

variable "user_ocid" {
  description = "OCI user OCID"
  type        = string
}

variable "fingerprint" {
  description = "API key fingerprint"
  type        = string
}

variable "private_key_path" {
  description = "Path to the OCI API private key file"
  type        = string
}

variable "private_key_password" {
  description = "Private key password (if your key is encrypted)"
  type        = string
  default     = ""
}

variable "region" {
  description = "OCI region"
  type        = string
}

#variable "secret_ocid" {
#  description = "OCID of the Vault secret storing your private key (base64-encoded)"
#  type        = string
#}
