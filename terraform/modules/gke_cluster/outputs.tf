output "name" {
  description = "The name of the cluster master. This output is used for interpolation with node pools, other modules."
  value       = google_container_cluster.gke.name
}

output "endpoint" {
  description = "The IP address of the cluster master."
  sensitive   = true
  value       = google_container_cluster.gke.endpoint
}

output "CIDR" {
  description = "The IP Address range of the CIDR block"
  sensitive   = true
  value       = [google_container_cluster.gke.private_cluster_config.*.master_ipv4_cidr_block]
}
