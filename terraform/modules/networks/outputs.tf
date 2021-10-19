output "subnets" {
  value = {
    for index, subnet in var.subnets :
    subnet.name => google_compute_subnetwork.this.*.name[index]
  }
}

output "name" {
  value = google_compute_network.vpc.name
}

output "id" {
  value = google_compute_network.vpc.id
}

output "subnet_ip_cidr" {
  description = "ip_cidr range of subnets"
  value = {
    for index, subnet in var.subnets :
    subnet.name => google_compute_subnetwork.this.*.ip_cidr_range[index]
  }
}

output "self_link" {
  value = google_compute_network.vpc.self_link
}