# SRE Tasks

## Task 1: Build a Script for Production Server Setup

### Objective
Build a script to install base servers for a production environment using any suitable automation tools (ansible*, salt stack, terraform, bash...).

### Requirements
The solution should set up the following components with consideration for a production-grade system:

1. **"Sysadmin" accounts:**
   - With sudo privileges
   - Set up hostname (dns)
   - Include commonly used CLI commands

2. **Docker daemon installation:**
   - Specify logging driver
   - Choose appropriate storage driver

3. **Server optimization:**
   - Prepare/tune for high network traffic workload

4. **Command logging:**
   - Log every command executed by users
   - Save logs in a specific file

### Implementation
We'll use a bash script for initial setup, which can be easily integrated with Ansible for more complex configurations.

#### Environment
- Operating System: Ubuntu 22.04 LTS (supported until 2027)

#### Quick Setup Guide

1. **Install Dependencies**
   - VirtualBox: [Download here](https://www.virtualbox.org/wiki/Downloads)
   - Vagrant: [Download here](http://www.vagrantup.com/downloads.html)
   - Ansible (Mac/Linux only): [Installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

   > **Note for Windows Users:** This guide is optimized for Mac and Linux. Windows support is limited at this time.

2. **Run the Virtual Machine**
   1. Clone this project
   2. Open Terminal and navigate to the project directory
   3. Run `vagrant up` and wait for Vagrant to complete the setup

3. **Additional Notes**
   - To shut down the VM: Run `vagrant halt` in the directory containing the `Vagrantfile`
   - To completely remove the VM: Run `vagrant destroy`
   - The `/vagrant/` directory in the VM is synced with the project directory on your host machine
   - To run the setup script: Execute `sudo sh /vagrant/scripts/setup-server.sh`

## Task 2: Monitoring Resource Utilization of a Tech Stack

### Monitoring Strategy

1. **Identify Key Metrics**
   - **Servers:** CPU, Disks, Disk I/O, Network I/O, uptime, average load
   - **Databases:** Query performance, connection count, replication lag, cache hit ratio
   - **Applications:** Response time, request rate, error rate, thread count, memory management
   - **Network:** Latency, bandwidth usage, packet loss, error rates
   - **Containers:** CPU/memory usage, container status, node resource utilization

2. **Choose Appropriate Monitoring Tools**
   - Prometheus: Real-time data collection and alerting
   - Grafana: Visualization of metrics collected by Prometheus
   - ELK Stack: Application log analysis

3. **Implement Data Collection**
   - Prometheus server: Collect metrics from exporters and store them
   - Logstash: Collect logs from various sources and forward to Elasticsearch
   - Elasticsearch: Store and index logs
   - Grafana: Create dashboards for metric visualization

4. **Set Up Alerting**
   - Prometheus Alertmanager: Send alerts based on Prometheus metrics

5. **Create Dashboards**
   - Server Health Dashboard
   - Database Performance Dashboard
   - Application Performance Dashboard
   - Network Performance Dashboard

### Scalable, Resilient, and Responsive Architecture

![Architecture Diagram](/images/architect.drawio.png)

#### Key Components

1. **User Layer**
   - Web Browsers
   - Mobile Apps
   - DNS for domain resolution

2. **Load Balancer**
   - Distributes requests across web servers

3. **Web Tier**
   - Multiple web servers (Server 1, Server 2, etc.)

4. **Data Tier**
   - Master DB for write operations
   - Slave DBs for read operations
   - Replication for data consistency

5. **Cache Layer**
   - e.g., Redis for frequently accessed data

6. **Monitoring and Management**
   - Logging
   - Metrics collection
   - Monitoring systems
   - Automation tools

## Task 3: Incident Response and Problem Resolution

### Steps for Resolving Service Issues

1. **Confirm the Alert**
   - Verify alert accuracy in monitoring systems
   - Review relevant metrics and parameters

2. **Assess Impact**
   - Determine scope and severity of the issue
   - Check for effects on end-users or other services

3. **Quick Health Check**
   - Verify network connectivity
   - Check system resources (CPU, RAM, Disk space)
   - Review status of relevant processes

4. **Analyze Logs**
   - Examine application, system, and database logs for errors or anomalies

5. **Review Recent Changes**
   - Check for recent updates, configuration changes, or deployments

6. **Implement Quick Fixes**
   - Restart services if necessary
   - Adjust system resources if they're the bottleneck

7. **Apply Long-term Solutions**
   - Address root causes to prevent recurrence
   - Update documentation and operational procedures

8. **Monitor and Report**
   - Continue monitoring the service post-fix
   - Prepare incident reports for stakeholders

### Real-world Example: Web Service Slowdown

#### Context
- Alert received: Web service response time spike
- User reports: Extremely slow page loads

#### Resolution Steps

1. **Alert Confirmation**
   - Monitoring dashboard shows response time increase from 200ms to 2000ms

2. **Impact Assessment**
   - All users affected
   - No other services impacted

3. **Quick Health Check**
   - Network connectivity normal
   - Web server CPU usage at 90%

4. **Log Analysis**
   - Logs indicate a sudden spike in request volume

5. **Change Review**
   - No recent code or configuration changes

6. **Quick Fix**
   - Increased number of web server nodes

7. **Long-term Solution**
   - Root cause: New marketing campaign causing traffic surge
   - Implement auto-scaling for rapid response to load increases
   - Collaborate with dev team to optimize code for high traffic

8. **Follow-up**
   - Continuous monitoring for 24 hours
   - Detailed report prepared for management and marketing teams

#### Outcome
- Service returned to normal within 30 minutes
- Improved capacity to handle high loads in the future
- Enhanced coordination between teams for predicting and preparing for large marketing campaigns