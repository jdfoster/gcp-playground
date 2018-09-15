data "google_compute_zones" "available" {
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_compute_instance" "default" {
 project = "${var.project}"
 zone = "${data.google_compute_zones.available.names[0]}"
 name = "tf-compute-1"
 machine_type = "f1-micro"
 boot_disk {
   initialize_params {
     image = "ubuntu-1604-xenial-v20180831"
   }
 }
 network_interface {
   network = "default"
   access_config {
   }
 }
 metadata {
    block-project-ssh-keys = false
  }
}

output "instance_id" {
 value = "${google_compute_instance.default.self_link}"
}
