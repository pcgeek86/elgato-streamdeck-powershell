function Send-StreamDeckImage {
    <#
    .Synopsis
    Sends an image to the Stream Deck WebSocket API

    .Description
    Stream Deck supports SVG and Base64-encoded PNG files, among perhaps others. This function is responsible
    for generating a dynamic SVG file, and encoding it for transmission to Elgato Stream Deck over the WebSocket API.
    
    This function really needs to be refactored, but I am not going to bother doing that for now. Unfortunately it's currently
    hard-coded to retrieve GPU wattage consumption from another function and render that out as an SVG file.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Net.WebSockets.ClientWebSocket] $WSClient,
        [string] $Context
    )

    try {
        LogMessage -Message 'Sending image to Stream Deck'
    
        if ($Context -eq '') {
            throw 'Context is empty. Please populate.'
            return
        }

        # Generate SVG file
        $GPUSVG = Get-Content -Raw -Path $PSScriptRoot/../assets/gpu.svg
        $Utilization = Get-GPUUtilization
        
        # Use PNG file on disk
        #$BashIcon = [System.Convert]::ToBase64String((Get-Content -AsByteStream -Path $PSScriptRoot/../assets/bash.png))
        
        # Create Bitmap with PowerShell
        #$Image = New-Bitmap

        $Payload = @{
            event = 'setImage'
            context = $Context
            payload = @{
                image = 'data:image/svg+xml;charset=utf8,{0}' -f $GPUSVG.Replace('GPUUTILIZATION', $Utilization)
                #image = 'data:image/png;base64,{0}' -f $BashIcon
                #image = 'data:image/png;base64,{0}' -f $Image
                target = 0
            }
        }
        
        $PayloadJson = $Payload | ConvertTo-Json
        LogMessage -Message $PayloadJson
        $PayloadBytes = [System.Text.Encoding]::UTF8.GetBytes($PayloadJson)
    
        $SendSegment = [System.ArraySegment[Byte]]::new($PayloadBytes)
        $SendToken = [System.Threading.CancellationToken]::new($false)
    
        LogMessage -Message 'Calling SendAsync() from Send-StreamDeckImage'
        $SendTask = $WSClient.SendAsync($SendSegment, [System.Net.WebSockets.WebSocketMessageType]::Binary, $true, $SendToken)
        while (!$SendTask.IsCompleted) {
            LogMessage -Message 'Updating image on Stream Deck device with GPU utilization'
            #Start-Sleep -Milliseconds 200
        }

    }
    catch {
        LogMessage -Message $PSItem
    }
}
