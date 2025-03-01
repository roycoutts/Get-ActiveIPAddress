function Get-ActiveIPAddress {
    <#
    .SYNOPSIS
        Gets the active IPv4 address associated with the default gateway interface.

    .DESCRIPTION
        The Get-ActiveIPAddress function retrieves the IPv4 address tied to the network interface that has the default gateway (0.0.0.0/0 route). This is typically the IP address used for most outbound network traffic, such as internet or local network connections.

        The function uses Get-NetRoute to identify the interface with the default gateway and then matches it to the corresponding IP address using Get-NetIPAddress.

    .OUTPUTS
        System.String
        Returns the IPv4 address (e.g., "192.168.0.24") of the active network interface as a string.

    .EXAMPLE
        PS C:\> Get-ActiveIPAddress
        192.168.0.24
        Returns the active IPv4 address for the primary network connection.

    .EXAMPLE
        PS C:\> $ip = Get-ActiveIPAddress
        PS C:\> Write-Output "My IP is: $ip"
        My IP is: 192.168.0.24
        Stores the active IP address in a variable and uses it in a message.

    .NOTES
        - Requires administrative privileges to access network configuration details in some environments.
        - Returns only IPv4 addresses; IPv6 is not supported by this function.
        - If multiple default gateways exist, it uses the first one returned by Get-NetRoute.

    .LINK
        Get-NetRoute
        https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-netroute

        Get-NetIPAddress
        https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-netipaddress
    #>

    # Check IP using `Get-NetRoute` and `Get-NetIPAddress`
    $activeInterface = Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Select-Object -Property InterfaceIndex, NextHop
    $activeIP        = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceIndex -eq $activeInterface.InterfaceIndex } | Select-Object -Property IPAddress
    Return $activeIP.IPAddress
}
