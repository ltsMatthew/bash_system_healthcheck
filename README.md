# System Health Overview Bash Script

## Introduction

This script provides a comprehensive overview of the system's health by checking runtime/uptime, service availability, CPU usage, memory/swap usage, disk space, and network interface statuses. 
It acts as a base template to build upon.

It's designed to give users a quick snapshot of their system's overall health. It checks and reports on various system metrics, making it easier to monitor and troubleshoot potential issues.

Script was created in the CentOS 7 Red Hat Linux environment. (might have issues with other distros)

## Features

- Checks system uptime
- Monitor services status
- Measure CPU usage
- Report on memory and swap usage
- Display disk space usage
- Show network interface statuses

## Installation

Since this is a Bash script, there is no installation required. Simply download the script and ensure it has execute permissions.

```bash
# Download the script
curl -O https://raw.githubusercontent.com/ltsMatthew/bash_system_healthcheck/main/system_healthcheck.sh

# Make the script executable
chmod +x syshealthcheck.sh
```

## Configuration

Before running the script, note you can remove the services you do not what to have displayed in the output of the script
eg. the ntp service or httpd service, feel free to add your own services if needed.

This script is system specfic, therefore some counters need to be changed to match your system's configuration.

There's currently 2 Sections in the script that would need to be changed to match that of your system so the "if statements" can function properly.
(You can also edit all the other counters as needed, remember this is just a base template!)

Section 1 - CPU, you will need to edit the "CPU_THRESHOLD" variable to the number you would like the Threshold to be, it should be based on the number of Cores your system has!

Section 2 - NETWORK, you will need to edit the "EXPECTED" interface variables in the script to match the number of UP, DOWN, and UNKNOWN interfaces on YOUR machine.

These configuration notes are in the script aswell, after changing these things and whatever else you'd like, you should be all good to go!

## Usage

To run the script, use the following command:

```bash
# Command Syntax
bash syshealthcheck.sh

# Can also be run like this
./syshealthcheck.sh
```

## Author

Matthew Adriaanzen
