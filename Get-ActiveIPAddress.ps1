# Method 1: Check the Default Gateway
# The IP address tied to the interface with the default gateway is typically the one used for most outbound traffic (e.g., to the internet or your local network). You can check this with Get-NetRoute:

function Get-ActiveIPAddress {
    # Check IP using `Get-NetRoute` and `Get-NetIPAddress`
    $activeInterface = Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Select-Object -Property InterfaceIndex, NextHop
    $activeIP        = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceIndex -eq $activeInterface.InterfaceIndex } | Select-Object -Property IPAddress
    Return $activeIP.IPAddress
}

# `Get-NetRoute -DestinationPrefix '0.0.0.0/0'` finds the default gateway (the route for all traffic not matched by other rules).
# `InterfaceIndex` identifies the active network interface.
# `Get-NetIPAddress` matches that interface to its IPv4 address.
# This will return the IP address (e.g., 192.168.0.24) associated with your primary network connection.
