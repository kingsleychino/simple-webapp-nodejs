# Simple Node Web App

A simple Node.js web application containerized with Docker and automated using Jenkins CI/CD pipelines and Terraform infrastructure provisioning.



## Project Overview

This project demonstrates a basic Node.js web application deployment workflow using:

- Node.js
- Docker
- Jenkins CI/CD
- Terraform Infrastructure as Code (IaC)

The application is designed to be lightweight, easy to deploy, and suitable for DevOps learning and automation workflows.



## Repository Structure

```bash
├── app/
│   ├── package.json
│   ├── Dockerfile
│   ├── app.js
│   ├── terraform/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
├── Jenkinsfile
└── README.md