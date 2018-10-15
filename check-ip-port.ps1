$ResultFile = "d:\test.txt"

$Addresses = @(
"1.1.1.1:80",
"1.1.1.2:21"
)

foreach ($AddressLine in $Addresses) {
    $AddressLineValues = $AddressLine -split ":"
    $IP = $AddressLineValues[0]
    $Port = $AddressLineValues[1]
    
    # Create a Net.Sockets.TcpClient object to use for
    # checking for open TCP ports.
    $Socket = New-Object Net.Sockets.TcpClient
        
    # Suppress error messages
    $ErrorActionPreference = 'SilentlyContinue'
        
    # Try to connect
    $Socket.Connect($IP, $Port)

    # Make error messages visible again
    $ErrorActionPreference = 'Continue'
        
    # Determine if we are connected.
    if ($Socket.Connected) {
        "${IP}`t$Port `topen" | Tee-Object -file $ResultFile -Append
        $Socket.Close()
    }
    else {
        "${IP}`t$Port`tclosed or filtered" | Tee-Object -file $ResultFile -Append
    }
        
    # Apparently resetting the variable between iterations is necessary.
    $Socket.Dispose()
    $Socket = $null
}