---
type: Reference
title: Terraform
description: Terraform is best at managing infrastructure topology.
tags: [reference, terraform]
timestamp: 2026-07-12T00:00:00Z
---

# Terraform
***

## What is this?
- Terraform is best at managing infrastructure topology.
- It allows you to keep the same exact code base while decidibg where to deploy (multiple environments without overlap). 
***

## How it works
- It is written in Go
- Terraform Core Workflow follows a 3-step workflow:
    - `terraform fmt -check`   → check Terraform file formatting without modifying files
    - `terraform validate`   → validate configuration syntax and catch errors before planning
    - `terraform init`   → prepare Terraform environment
    - `terraform plan`   → preview infrastructure changes
    - `terraform apply`  → execute infrastructure changes
***

## `terraform init`
- Initializes the Terraform working directory.
- Downloads provider plugins (AWS, Azure, GCP, etc.)
- Initializes modules
- Configures backend/state storage
- Creates the `.terraform/` directory locally so it can manage infrastructure.
- I does **not** create or modify infrastructure.

## `terraform plan`
- Previews infrastructure changes without applying them.
- Reads Terraform configuration files (`.tf`)
- Reads current infrastructure state
- Compares desired state vs actual state
- Shows what changes would occur actinng as a safe “dry run” before making changes.
- It does **not** change infrastructure.

```bash
- `+` → create resource
- `~` → modify resource
- `-` → destroy resource
```

# `terraform apply`
- Applies infrastructure changes.
- Calls cloud provider APIs
- Creates/modifies/deletes infrastructure resources
- Updates the Terraform state file
- Makes the actual infrastructure match the Terraform configuration.

## CI/CD
- What to run in CI: 
```bash
terraform fmt -check
terraform validate
terraform init
terraform plan
```
- What to run in CD:
```bash
terraform init
terraform apply -auto-approve
```


## Rules and autoscaling how they work
- A useful analogy: Terraform is the architect while AWS Auto Scaling is the manager.
- Terraform writes the rule: "This service may have between 2 and 10 workers. Try to keep CPU around 60%."
```hcl
resource "aws_appautoscaling_target" "backend" {
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/<env>/<service-name>"

  min_capacity = 2
  max_capacity = 10
}
resource "aws_appautoscaling_policy" "backend_cpu" {
  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
```
- AWS Auto Scaling watches the workload every minute and hires or lays off workers within those limits. Terraform doesn't participate after the rule has been created.
***


## Flexibility
- It can run from a CI/CD pipeline
- It can be run from a command line
- It can deal with your local stack and not only cloud infrastructure
***

## Limitations
- Terraform is NOT a runtime traffic orchestrator.
- Do not use this for canary releases, per-request routing, feature flags and A/B testing.
Terraform is not designed to: Continuously react to load. Essentially the work of an autoscaler.
***

## References
- [Deploying Multiple Environments with Terraform](https://medium.com/capital-one-tech/deploying-multiple-environments-with-terraform-kubernetes-7b7f389e622)
***