# Terraform GCP Cloud Run

Terraform module for deploying Cloud Run services and jobs on Google Cloud Platform with custom domains, VPC connectors, and secret management.

## Architecture

```mermaid
graph TB
    subgraph GCP["Google Cloud Platform"]
        style GCP fill:#e8f0fe,stroke:#4285f4,stroke-width:2px,color:#1a73e8

        subgraph CloudRun["Cloud Run"]
            style CloudRun fill:#e6f4ea,stroke:#34a853,stroke-width:2px,color:#137333
            SVC["Cloud Run v2 Services"]
            JOB["Cloud Run v2 Jobs"]
            IAM["IAM Policy Bindings"]
            style SVC fill:#ceead6,stroke:#34a853,color:#137333
            style JOB fill:#ceead6,stroke:#34a853,color:#137333
            style IAM fill:#ceead6,stroke:#34a853,color:#137333
        end

        subgraph Networking["VPC Networking"]
            style Networking fill:#fce8e6,stroke:#ea4335,stroke-width:2px,color:#c5221f
            VPC["VPC Access Connector"]
            style VPC fill:#fad2cf,stroke:#ea4335,color:#c5221f
        end

        subgraph Secrets["Secret Manager"]
            style Secrets fill:#f3e8fd,stroke:#a142f4,stroke-width:2px,color:#7627bb
            SEC["Secrets"]
            style SEC fill:#e9d5fc,stroke:#a142f4,color:#7627bb
        end

        subgraph DNS["Custom Domains"]
            style DNS fill:#fef7e0,stroke:#fbbc04,stroke-width:2px,color:#e37400
            DOM["Domain Mappings"]
            style DOM fill:#feefc3,stroke:#fbbc04,color:#e37400
        end
    end

    USERS["External Users"] -->|HTTPS| DOM
    DOM --> SVC
    SVC -->|private network| VPC
    SVC -->|env vars| SEC
    JOB -->|env vars| SEC
    JOB -->|private network| VPC
    IAM -->|controls access| SVC

    style USERS fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
```

## Features

- Cloud Run v2 services with auto-scaling, concurrency, and traffic management
- Cloud Run v2 jobs with configurable task count and retry policies
- VPC Access Connector for private network connectivity
- Secret Manager integration for secure environment variables
- IAM bindings for authenticated and unauthenticated access
- Custom domain mapping support
- Comprehensive labeling

## Usage

### Basic

```hcl
module "cloud_run" {
  source = "github.com/kogunlowo123/terraform-gcp-cloud-run"

  project_id = "my-gcp-project"
  region     = "us-central1"

  services = {
    "my-api" = {
      image                 = "gcr.io/my-gcp-project/my-api:latest"
      allow_unauthenticated = true
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 5.10.0 |
| google-beta | >= 5.10.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The GCP project ID | `string` | n/a | yes |
| region | The GCP region | `string` | `"us-central1"` | no |
| services | Map of Cloud Run v2 services | `map(object)` | `{}` | no |
| jobs | Map of Cloud Run v2 jobs | `map(object)` | `{}` | no |
| vpc\_connectors | Map of VPC Access connectors | `map(object)` | `{}` | no |
| labels | Default labels | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| service\_urls | Map of service names to URLs |
| service\_ids | Map of service names to IDs |
| job\_ids | Map of job names to IDs |
| vpc\_connector\_ids | Map of VPC connector names to IDs |

## License

MIT Licensed. See [LICENSE](LICENSE) for full details.
