function Test-StreamDeck {
    <#
    .Synopsis
    Determines if Elgato Stream Deck is still running or not.

    .Description
    If StreamDeck.exe is no longer running, we should forcefully terminate the WebSocket connection
    and close the PowerShell process (pwsh.exe).
    
    .Notes
    Copyright (c) 2020 Trevor Sullivan
    Licensed under MIT (LICENSE.md)
    #>
    [CmdletBinding()]
    param ()

    return $True -eq (Get-Process -Name StreamDeck -ErrorAction Ignore)
}