function ConvertTo-Base64 {
    [CmdletBinding(DefaultParameterSetName='Encode')]
    param (
        [Parameter(Mandatory=$true, Position=0, ParameterSetName='Encode')]
        [Alias('e')]
        [switch]$Encode,

        [Parameter(Mandatory=$true, Position=0, ParameterSetName='Decode')]
        [Alias('d')]
        [switch]$Decode,

        [Parameter(Mandatory=$false, Position=1, ValueFromPipeline=$true)]
        [string]$InputString,

        [Parameter(Mandatory=$false, Position=2)]
        [Alias('i')]
        [string]$Image,

        [Parameter(Mandatory=$false, Position=3)]
        [Alias('o')]
        [string]$Output,

        [Parameter(Mandatory=$false, Position=4)]
        [Alias('txt')]
        [string]$Base64Txt
    )
    
    process {
        if ($Encode) {
            if ($Image) {
                # If an image path is provided, read the image and convert to Base64.
                if (Test-Path $Image) {
                    $imageBytes = [System.IO.File]::ReadAllBytes($Image)
                    $base64 = [System.Convert]::ToBase64String($imageBytes)
                    Write-Output $base64
                } else {
                    Write-Error "Invalid image path: $Image"
                }
            } elseif ($InputString) {
                # If text input is provided, convert to Base64.
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
                $base64 = [System.Convert]::ToBase64String($bytes)
                Write-Output $base64
            } else {
                Write-Error "Please provide the text or image path to be encoded."
            }
        }
        elseif ($Decode) {
            if ($Base64Txt) {
                # If a Base64 file path is provided, read the contents of the file and decode it.
                if (Test-Path $Base64Txt) {
                    $base64String = Get-Content -Path $Base64Txt -Raw
                    try {
                        $imageBytes = [System.Convert]::FromBase64String($base64String)
                        [System.IO.File]::WriteAllBytes($Output, $imageBytes)
                        Write-Output "Image saved to: $Output"
                    } catch {
                        Write-Error "Base64 decoding failed: $_"
                    }
                } else {
                    Write-Error "The Base64 file path is invalid: $Base64Txt"
                }
            } else {
                # If the text is Base64 decoded, the decoding result will be output directly.
                $bytes = [System.Convert]::FromBase64String($InputString)
                $decodedString = [System.Text.Encoding]::UTF8.GetString($bytes)
                Write-Output $decodedString
            }
        }
    }
}