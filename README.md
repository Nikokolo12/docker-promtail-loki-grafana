# Grafana Monitoring Stack with Nginx and Node Exporter

This repository provides an implementation of the Grafana monitoring stack. 

## Repository Structure

- **docker/**: This folder contains configurations for setting up two Docker-based environments:
  1. **Monitoring Stack**: Includes Grafana, Loki, and Prometheus for comprehensive monitoring and log management.
  2. **Nginx Website**: A simple Nginx-based web server setup, combined with Node Exporter and Promtail to gather metrics and logs.

- **scripts/**: Contains the bootstrap script to streamline the setup process.
- **dashboards/**: Contains created templates for Loki and Prometheus dashboards

## Features

- **Grafana**: Visualize and monitor your infrastructure metrics and logs in real-time.
- **Loki**: A log aggregation system designed to work well with Grafana.
- **Prometheus**: A powerful metrics collection and alerting toolkit.
- **Nginx Website**: A simple web server setup using Nginx.
- **Node Exporter**: Collects hardware and OS metrics exposed by *NIX kernels.
- **Promtail**: Responsible for gathering logs from the Nginx container and pushing them to Loki.
- **AlertManager**: Sends alerts via Telegram Bot in case high RAM, CPU usage and server crash


