# powershell-network-discovery

PowerShell script for quick network discovery using SNMP.

## Prerequisites

- Windows operating system with PowerShell 5.1 or higher.
- SNMP PowerShell module installed on the system.
- Devices configured to respond to SNMP requests with the correct community string.

## Installation

Run the following command in a PowerShell session:

```powershell
Install-Module -Name SNMP -Scope CurrentUser
```

## Usage

Import the script into a PowerShell session and call the `discover_network` function with the required parameters.

```powershell
# Import the script
. .\path_to_script\network_analyzer.ps1

# Run network discovery on a specific IP
discover_network -specific_ip "192.168.1.100"

# Run network discovery on an entire subnet
discover_network -subnet "192.168.1.0/24"
```
