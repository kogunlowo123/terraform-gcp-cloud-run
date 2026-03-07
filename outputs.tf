output "service_urls" {
  description = "Map of Cloud Run service names to their URLs"
  value       = { for k, v in google_cloud_run_v2_service.this : k => v.uri }
}

output "service_ids" {
  description = "Map of Cloud Run service names to their IDs"
  value       = { for k, v in google_cloud_run_v2_service.this : k => v.id }
}

output "service_conditions" {
  description = "Map of Cloud Run service names to their conditions"
  value       = { for k, v in google_cloud_run_v2_service.this : k => v.conditions }
}

output "job_ids" {
  description = "Map of Cloud Run job names to their IDs"
  value       = { for k, v in google_cloud_run_v2_job.this : k => v.id }
}

output "job_conditions" {
  description = "Map of Cloud Run job names to their conditions"
  value       = { for k, v in google_cloud_run_v2_job.this : k => v.conditions }
}

output "vpc_connector_ids" {
  description = "Map of VPC connector names to their IDs"
  value       = { for k, v in google_vpc_access_connector.this : k => v.id }
}

output "vpc_connector_self_links" {
  description = "Map of VPC connector names to their self links"
  value       = { for k, v in google_vpc_access_connector.this : k => v.self_link }
}
