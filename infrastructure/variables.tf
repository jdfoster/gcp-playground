variable "project" {}

variable "credentials" {}

variable "ssh_user" {}

variable "ssh_pub_key" {
  description = "Path to public key to be used."
  default  = "./keys/josh_rsa.pub"
}

variable "region" {
  default = "europe-west2"
}
