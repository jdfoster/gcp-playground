terraform {
  backend "gcs" {
    # bucket      = "fluffy-kitty-terraform-state"
    # credentials = "/home/vagrant/.config/gcloud/deploy-fluffy-kitty.json"
    prefix      = "terraform/state"
    # project     = "fluffy-kitty"
 }
}
