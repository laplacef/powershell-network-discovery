function get_snmp_data {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ip_address
    )

    # Define SNMP community string and OID (Object Identifier)
    $community = "public"
    $oid = "1.3.6.1.2.1.1.1.0" # OID for system description

    # Perform SNMP get operation
    try {
        $snmpResult = Get-SnmpData -OID $oid -Community $community -IP $ip_address
        return $snmpResult
    }
    catch {
        Write-Host "An error occurred: $($_.Exception.Message)"
        return $null
    }
}

function discover_network {
    param (
        [string]$subnet = "192.168.1.0/24",
        [string]$specific_ip = ""
    )
    $active_devices = @()
    
    if ($specific_ip -ne "") {
        # Scan a specific IP address
        if (Test-Connection -ComputerName $specific_ip -Count 1 -Quiet) {
            $snmp_data = get_snmp_data -ip_address $specific_ip
            $device = New-Object PSObject -Property @{
                IPAddress = $specific_ip
                HostName  = [System.Net.Dns]::GetHostEntry($specific_ip).HostName
                SnmpData  = $snmp_data
            }
            $active_devices += $device
        }
    }
    else {
        # Scan a range of IP addresses
        $start_ip = [System.Net.IPAddress]::Parse(($subnet -split '/')[0])
        $cidr = [int](($subnet -split '/')[1])
        $range = [Math]::Pow(2, (32 - $cidr))
        for ($i = 1; $i -lt $range - 1; $i++) {
            $ip = $start_ip.GetAddressBytes()
            $ip[3] = $ip[3] -as [byte] + $i
            $ip_address = [System.Net.IPAddress]::new($ip) -as [string]
            
            if (Test-Connection -ComputerName $ip_address -Count 1 -Quiet) {
                $snmp_data = get_snmp_data -ip_address $ip_address
                $device = New-Object PSObject -Property @{
                    IPAddress = $ip_address
                    HostName  = [System.Net.Dns]::GetHostEntry($ip_address).HostName
                    SnmpData  = $snmp_data
                }
                $active_devices += $device
            }
        }
    }

    return $active_devices
}
