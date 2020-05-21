
function LogMessage {
    [CmdletBinding()]
    param (
        [string[]] $Message
    )
    foreach ($item in $Message) {
        # Un-comment the following line to enable script logging for troubleshooting purposes.
        # Otherwise, there's no need to persist the log to the filesystem indefinitely.
        # NOTE: I haven't implemented log rotation, so this file could get rather large.
        # Add-Content -Path $LogPath -Value ('{0} {1}' -f (Get-Date -Format u), $item)
    }
}
