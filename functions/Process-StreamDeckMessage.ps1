function Process-StreamDeckMessage {
    <#
    .Synopsis
    Processes any messages received by Receive-StreamDeckMessage function. Currently only processes messages containing a `Context` key in the JSON result, 
    as this is a dependency for Send-StreamDeckImage to know "where" to send image updates on Stream Deck hardware.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Message
    )
    $MessageObject = $Message | ConvertFrom-Json
    if ($MessageObject.Context) {
        $global:Context = $MessageObject.Context
    }
}