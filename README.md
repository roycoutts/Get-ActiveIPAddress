# Get-ActiveIPAddress

# Get-IPAddress.ps1

PowerShell Documentation

## Get-ActiveIPAddress

### Description
The `Get-ActiveIPAddress` function retrieves the active IPv4 address of the primary network interface by analyzing the default gateway route. This method ensures that the IP address returned is the one actively used for outbound traffic.

### Syntax
```powershell

Get-ActiveIPAddress
```

### Return Value
- **String**: The IPv4 address assigned to the active network interface.

### Parameters
This function does not take any parameters.

### How It Works
1. Uses `Get-NetRoute` to find the default gateway route (`0.0.0.0/0`).
2. Extracts the `InterfaceIndex` of the network adapter associated with this route.
3. Retrieves the IPv4 address assigned to that interface using `Get-NetIPAddress`.
4. Returns the IP address of the active network connection.

### Example Usage
```powershell

$myIP = Get-ActiveIPAddress
Write-Output "My active IP address is: $myIP"
```

---

## Get-ActiveIPAddress2

### Description
The `Get-ActiveIPAddress2` function determines the active IPv4 address by performing a network test to a known external server (Google’s public DNS at 8.8.8.8). This method is useful for identifying the exact source address used for outbound connections.

### Syntax
```powershell

Get-ActiveIPAddress2
```

### Return Value
- **String**: The IPv4 address of the interface used for reaching the specified remote server.

### Parameters
This function does not take any parameters.

### How It Works
1. Uses `Test-NetConnection` to establish a connection to `8.8.8.8`.
2. Retrieves the `SourceAddress` property from the detailed test results.
3. Returns the source IP address used for the connection.

### Example Usage
```powershell

$myIP = Get-ActiveIPAddress2
Write-Output "My outbound IP address is: $myIP"
```

### Notes
- The function uses Google’s DNS server (8.8.8.8) by default. You can modify this to test against a local network device (e.g., your router’s IP) if needed.
- This method is useful when multiple interfaces exist, and you need to determine which one is actually being used for internet access.

---

## Get-ActiveIPAddress

```powershell

function Get-ActiveIPAddress {
    # Check IP using `Get-NetRoute` and `Get-NetIPAddress`
    $activeInterface = Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Select-Object -Property InterfaceIndex, NextHop
    $activeIP        = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceIndex -eq $activeInterface.InterfaceIndex } | Select-Object -Property IPAddress
    Return $activeIP.IPAddress
}
```

## Get-ActiveIPAddress2

```powershell

function Get-ActiveIPAddress2 {
    # Check IP using `Test-NetConnection`
    $activeIP = (Test-NetConnection -ComputerName '8.8.8.8' -InformationLevel Detailed).SourceAddress.IPAddress
    Return $activeIP
}
```

