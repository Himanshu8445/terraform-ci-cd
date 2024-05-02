## Terraform CI-CD ##

This repository contains the code for setting up management and landing zone using Terraform and GitHub Actions.

## Overview

This pipeline is designed to automate the process of deploying infrastructure using Terraform. The pipeline is designed to trigger below operations:
 
1. **Setup:** It sets up the necessary environment for running Terraform commands.
2. **Validation:** It validates the syntax of the Terraform files.
3. **Plan:** It creates Terraform plan for respective environment, whenever any pull request is raised.
4. **Apply:** Terraform apply will run when pull request is merged to "main" branch.

## Directory

1. **.github/workflows:** Contains GitHub actions workflows for automating deployment tasks. It has yaml file for Dev, Test, Prod & management zone.
2. **modules:** It has terraform modules used across environments.
3. **managementzone:** It has configuration files to deploy management zone. 
4. **landingzone-dev:** It has configuration files to deploy DEV environment landing zone.
5. **landingzone-test:** It has configuration files to deploy TEST environment landing zone.
6. **landingzone-prod:** It has configuration files to deploy PROD environment landing zone.

**Note** - You can call Terraform modules in respective environment. There is one resource group module already called, you can follow same process to call other modules too.

## GitHub Environment

- Deployment to each environment is getting controlled by GitHub environments. Each GitHub environment has SPN ID, SPN secret, Subscription ID & Tenant ID.
  ![image](https://github.com/Himanshu8445/terraform-ci-cd/assets/107118596/72441774-61ac-444d-9cec-49f44444b1b2)

### Prerequisites

- An Azure subscription 
- Service principal with the necessary permissions to create resources.
- A GitHub account.

## Running Terraform plan
 
Consider a case that there is a need to deploy resource group in "landingzone-dev". Please follow below steps:

- Navigate to landingzone-dev -> value.auto.tfvars -> Add resource group details under "resource_groups" variable.
- Create a feature branch and raise a pull request. 
- Once pull request is raised, it will run terraform plan automatically.
- Review terraform plan.

## Running Terraform apply

- After reviewing terraform plan, assign a reviewer to your pull request.
- Once pull request is merged to "main" branch, terraform apply will run and resources will get deployed.

## Authors

**Amit Srivastav** - amit.srivastav@microsoft.com
**Tavish Malhotra** - tavish.malhotra@microsoft.com
**Himanshu Sharma** - himshar@microsoft.com

## Reference Architecture

