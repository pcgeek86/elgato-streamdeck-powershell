function Connect-StreamDeck {
    <#
    .Synopsis
    Establishes a WebSocket connection to the Elgato Stream Deck.

    .Description
    The Elgato Stream Deck software triggers callps.cmd, which passes an array of arguments to the main 
    entrypoint of this plug-in, script.ps1. One of these arguments / parameters is the WebSocket port number
    that Stream Deck is requesting this plug-in to connect back to. This argument is passed into this function
    by script.ps1, so it knows "where" to connect.

    To the best of my knowledge, the host is always localhost (127.0.0.1 IPv4 or ::1 IPv6 (unconfirmed))
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int] $Port
    )
    $Websocket = [System.Net.WebSockets.ClientWebSocket]::new()
    $CancelToken = [System.Threading.CancellationToken]::new($false)

    $WsUri = 'ws://127.0.0.1:{0}' -f $Port
    $ConnectTask = $Websocket.ConnectAsync($WsUri, $CancelToken)
    while (!$ConnectTask.IsCompleted) {
        LogMessage -Message ($ConnectTask | ConvertTo-Json)
        Start-Sleep -Milliseconds 1000
    }
    LogMessage -Message 'Finished connecting to Stream Deck'
    return $Websocket
}
