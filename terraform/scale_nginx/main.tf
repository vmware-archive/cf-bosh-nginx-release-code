provider "google" {
  project     = "${var.gcp_project_name}"
  region      = "us-central1"
}

resource "google_compute_target_pool" "default" {
  name = "nginx-pool"
}


resource "google_compute_firewall" "default" {
  name = "allow-http"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  target_tags = ["nginx"]
}

resource "google_compute_address" "default" {
  name = "nginx-address"
}

resource "google_compute_forwarding_rule" "default" {
  name = "nginx-lb"
  ip_protocol = "TCP"
  ip_address = "${google_compute_address.default.address}"
  target = "${google_compute_target_pool.default.self_link}"
}

output "ip" {
  value = "${google_compute_address.default.address}"
}
