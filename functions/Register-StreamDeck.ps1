function Register-StreamDeck {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $RegisterEvent,
        [Parameter(Mandatory = $true)]
        [string] $PluginUUID,
        [Parameter(Mandatory = $true)]
        [System.Net.WebSockets.ClientWebSocket] $WSClient
    )

    $JsonMessage = @{
        event = $RegisterEvent
        uuid = $PluginUUID
    } | ConvertTo-Json

    try {
        $ByteList = [System.Text.Encoding]::UTF8.GetBytes($JsonMessage)
        $RegisterSegment = [System.ArraySegment[Byte]]::new($ByteList)
        $RegisterCT = [System.Threading.CancellationToken]::new($false)
        $RegisterTask = $WSClient.SendAsync($RegisterSegment, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $RegisterCT)
        while (!$RegisterTask.IsCompleted) {
            LogMessage -Message 'Waiting for Stream Deck registration to complete'
            LogMessage -Message ($RegisterTask | ConvertTo-Json)
            Start-Sleep -Seconds 2
        }
    }
    catch {
        LogMessage -Message $PSItem
        exit
    }
}
