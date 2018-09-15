resource "google_compute_project_metadata_item" "default" {
  project = "${var.project}"
  key = "ssh-keys"
  value = "${var.ssh_user}:${file(var.ssh_pub_key)}"
}
