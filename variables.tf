variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for Cloud Run resources"
  type        = string
  default     = "us-central1"
}

# Cloud Run Service variables
variable "services" {
  description = "Map of Cloud Run v2 services to create"
  type = map(object({
    image                = string
    port                 = optional(number, 8080)
    cpu                  = optional(string, "1000m")
    memory               = optional(string, "512Mi")
    min_instance_count   = optional(number, 0)
    max_instance_count   = optional(number, 100)
    timeout              = optional(string, "300s")
    execution_environment = optional(string, "EXECUTION_ENVIRONMENT_GEN2")
    ingress              = optional(string, "INGRESS_TRAFFIC_ALL")
    service_account      = optional(string, null)
    env_vars             = optional(map(string), {})
    secret_env_vars = optional(map(object({
      secret  = string
      version = optional(string, "latest")
    })), {})
    vpc_connector        = optional(string, null)
    vpc_egress           = optional(string, "PRIVATE_RANGES_ONLY")
    allow_unauthenticated = optional(bool, false)
    labels               = optional(map(string), {})
  }))
  default = {}
}

# Cloud Run Job variables
variable "jobs" {
  description = "Map of Cloud Run v2 jobs to create"
  type = map(object({
    image              = string
    cpu                = optional(string, "1000m")
    memory             = optional(string, "512Mi")
    task_count         = optional(number, 1)
    max_retries        = optional(number, 3)
    timeout            = optional(string, "600s")
    service_account    = optional(string, null)
    env_vars           = optional(map(string), {})
    vpc_connector      = optional(string, null)
    labels             = optional(map(string), {})
  }))
  default = {}
}

# VPC Connector variables
variable "vpc_connectors" {
  description = "Map of VPC Access connectors to create"
  type = map(object({
    network        = string
    ip_cidr_range  = string
    min_throughput = optional(number, 200)
    max_throughput = optional(number, 300)
    machine_type   = optional(string, "e2-micro")
    min_instances  = optional(number, 2)
    max_instances  = optional(number, 3)
  }))
  default = {}
}

# Custom domain mapping
variable "domain_mappings" {
  description = "Map of custom domain mappings for Cloud Run services"
  type = map(object({
    service_name = string
    domain       = string
  }))
  default = {}
}

variable "labels" {
  description = "Default labels to apply to all resources"
  type        = map(string)
  default     = {}
}
