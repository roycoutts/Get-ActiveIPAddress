# Method 2: Test Connectivity to a Known Address
# You can test which IP address is used to reach a specific destination (like your router or an external server) using Test-NetConnection:

function Get-ActiveIPAddress2 {
    # Check IP using `Test-NetConnection`
    $activeIP = (Test-NetConnection -ComputerName '8.8.8.8' -InformationLevel Detailed).SourceAddress.IPAddress
    Return $activeIP
}

# Test-NetConnection pings a target (here, Google’s DNS server 8.8.8.8) and returns the source IP address used for the connection.
# Replace 8.8.8.8 with your router’s IP (e.g., 192.168.0.1) if you want to test local network usage.
# This directly shows which IP is being used for that traffic when you are encountering 2 different IP addresses being returned.
