function Receive-StreamDeckMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Net.WebSockets.ClientWebSocket] $WSClient
    )
    try {
        LogMessage -Message 'Receiving message ...'
        $ByteArray = New-Object -TypeName Byte[] -ArgumentList 4096
        $ReceiveSegment = [System.ArraySegment[Byte]]::new($ByteArray)
        $ReceiveCT = [System.Threading.CancellationToken]::new($false)
        $ReceiveTask = $WSClient.ReceiveAsync($ReceiveSegment, $ReceiveCT)

        $WaitCounter = 0
        while (!$ReceiveTask.IsCompleted) {
            #Send-StreamDeckImage
            if ($WaitCounter -gt 1) { break }
            $WaitCounter += 1
            LogMessage -Message 'Waiting for message ...'
            Start-Sleep -Milliseconds 5000
        }
        LogMessage -Message ('Received message length: {0}' -f $ReceiveTask.Result.Count)
        $JsonResult = [System.Text.Encoding]::UTF8.GetString($ReceiveSegment.ToArray(), 0, $ReceiveTask.Result.Count)
        LogMessage -Message $JsonResult
        Process-StreamDeckMessage -Message $JsonResult
    }
    catch {
        LogMessage -Message $PSItem
        exit
    }
}
