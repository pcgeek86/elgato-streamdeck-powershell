
function New-Bitmap {
    <#
    .Synopsis
    Creates an in-memory bitmap and writes some text to it. Returns a Base64 string representing the bitmap, rendered as a PNG.

    .Description
    This function was used during prototyping of this PowerShell plug-in for Elgato Stream Deck. I was having trouble getting the
    Stream Deck to render text, using certain settings, as an SVG file. I tried using a bitmap instead, which worked, but after I
    figured out a work-around for SVG, I went that route instead. I'm leaving this function in this project, in case anyone else 
    wants to go the bitmap route instead of SVG.
    #>
    [CmdletBinding()]
    param (

    )

    $Text = Get-GPUUtilization

    $Bitmap = [System.Drawing.Bitmap]::new(72, 72)

    $Font = [System.Drawing.Font]::new('Consolas', 30)
    $Brush = [System.Drawing.Brushes]::Red
    $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)

    $Graphics.FillRectangle([System.Drawing.Brushes]::Gainsboro, 0, 0, $Bitmap.Width, $Bitmap.Height)
    $Graphics.DrawString($Text, $Font, $Brush, 0, 4)
    $Graphics.Dispose()

    $MemoryStream = [System.IO.MemoryStream]::new()
    $Bitmap.Save($MemoryStream, [System.Drawing.Imaging.ImageFormat]::Png)
    $Base64 = [System.Convert]::ToBase64String($MemoryStream.ToArray())
    $MemoryStream.Close()
    return $Base64
}
