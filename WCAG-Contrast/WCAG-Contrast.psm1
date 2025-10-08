<#
.SYNOPSIS
Calculates the relative luminance of a color based on its RGB components.

.DESCRIPTION
This function computes the relative luminance of a color using the RGB values provided as input. The luminance is calculated by first linearizing the sRGB color values and then applying the luminance formula based on the coefficients for red, green, and blue channels.

.PARAMETER R
The red component of the color (0-255).

.PARAMETER G
The green component of the color (0-255).

.PARAMETER B
The blue component of the color (0-255).

.EXAMPLE
Get-RelactiveLuminance -R 255 -G 255 -B 255
This example calculates the relative luminance of white (RGB: 255, 255, 255).

.NOTES
Author: Azuremy
Date: 2025-10-08
#>
function Get-RelactiveLuminance {
    param (
        [int]$R,
        [int]$G,
        [int]$B
    )
    
    # Convert RGB values to the [0, 1] range
    $R_sRGB = $R / 255.0
    $G_sRGB = $G / 255.0
    $B_sRGB = $B / 255.0

    # Linearize each channel
    if ($R_sRGB -le 0.03928) {
        $R_linear = $R_sRGB / 12.92
    }
    else {
        $R_linear = [math]::Pow((($R_sRGB + 0.055) / 1.055), 2.4)
    }

    if ($G_sRGB -le 0.03928) {
        $G_linear = $G_sRGB / 12.92
    }
    else {
        $G_linear = [math]::Pow((($G_sRGB + 0.055) / 1.055), 2.4)
    }

    if ($B_sRGB -le 0.03928) {
        $B_linear = $B_sRGB / 12.92
    }
    else {
        $B_linear = [math]::Pow((($B_sRGB + 0.055) / 1.055), 2.4)
    }

    # Calculate relative brightness
    $luminance = 0.2126 * $R_linear + 0.7152 * $G_linear + 0.0722 * $B_linear

    return $luminance
}

<#
.SYNOPSIS
Calculates the contrast ratio between two colors based on their luminance.

.DESCRIPTION
This function computes the contrast ratio between two colors by calculating their relative luminance values and applying the formula for contrast ratio.

.PARAMETER Color1
The first color in the comparison, provided as an array of RGB values.

.PARAMETER Color2
The second color in the comparison, provided as an array of RGB values.

.EXAMPLE
Get-ContrastRatio -Color1 @(255, 255, 255) -Color2 @(0, 0, 0)
This example calculates the contrast ratio between white (RGB: 255, 255, 255) and black (RGB: 0, 0, 0).

.NOTES
Author: Azuremy
Date: 2025-10-08
#>
function Get-ContrastRatio {
    param (
        [int[]]$Color1,
        [int[]]$Color2
    )
    
    $lum1 = Get-RelactiveLuminance -R $Color1[0] -G $Color1[1] -B $Color1[2]
    $lum2 = Get-RelactiveLuminance -R $Color2[0] -G $Color2[1] -B $Color2[2]

    # Make sure lum1 is a brighter color
    if ($lum1 -lt $lum2) {
        $temp = $lum1
        $lum1 = $lum2
        $lum2 = $temp
    }

    $contrastRatio = ($lum1 + 0.05) / ($lum2 + 0.05)

    return [math]::Round($contrastRatio, 2)
}

<#
.SYNOPSIS
Tests whether a contrast ratio meets WCAG compliance criteria for accessibility.

.DESCRIPTION
This function checks if the contrast ratio between foreground and background colors meets the WCAG guidelines for accessibility, based on text size and whether the text is bold.

.PARAMETER ContrastRatio
The contrast ratio between the two colors being compared.

.PARAMETER TextSize
The font size of the text (in points).

.PARAMETER IsBold
Indicates whether the text is bold. The default is $false.

.EXAMPLE
Test-WCAGComliance -ContrastRatio 7.5 -TextSize 16
This example checks whether the contrast ratio of 7.5 meets the WCAG AA or AAA compliance level for text size 16pt.

.NOTES
Author: Azuremy
Date: 2025-10-08
#>
function Test-WCAGComliance {
    param (
        [double]$ContrastRatio,
        [int]$TextSize,
        [bool]$IsBold = $false
    )

    # Determine whether the text is 'large text'
    $isLargeText = ($TextSize -ge 18) -or ($TextSize -ge 14 -and $IsBold)

    if ($isLargeText) {
        if ($ContrastRatio -ge 3.0) {
            return "AAA"
        }
        elseif ($ContrastRatio -ge 4.5) {
            return "AA"
        }
        else {
            return "Fail"
        }
    }
    else {
        if ($ContrastRatio -ge 7.0) {
            return "AAA"
        }
        elseif ($ContrastRatio -ge 4.5) {
            return "AA"
        }
        else {
            return "Fail"
        }
    }
}

<#
.SYNOPSIS
Converts a hex color code to RGB values.

.DESCRIPTION
This function takes a hex color code in the format #RRGGBB or #RGB and converts it to an array of RGB values.

.PARAMETER HexColor
The hex color code to be converted, in the format #RRGGBB or #RGB.

.EXAMPLE
ConvertFrom-HexColor -HexColor "#FF5733"
This example converts the hex color "#FF5733" to RGB values.

.NOTES
Author: Azuremy
Date: 2025-10-08
#>
function ConvertFrom-HexColor {
    param (
        [string]$HexColor
    )

    $HexColor = $HexColor.TrimStart('#')

    if ($HexColor.Length -eq 3) {
        $HexColor = -join ($HexColor[0], $HexColor[0], $HexColor[1], $HexColor[1], $HexColor[2], $HexColor[2])
    }

    if ($HexColor.Length -ne 6) {
        throw "Invalid hex color format. Use #RRGGBB or #RGB."
    }
    
    $R = [Convert]::ToInt32($HexColor.Substring(0, 2), 16)
    $G = [Convert]::ToInt32($HexColor.Substring(2, 2), 16)
    $B = [Convert]::ToInt32($HexColor.Substring(4, 2), 16)

    return @($R, $G, $B)
}

<#
.SYNOPSIS
Tests the WCAG contrast ratio between two colors.

.DESCRIPTION
This function calculates the contrast ratio between two colors and checks if it meets WCAG accessibility guidelines. It also takes into account text size and whether the text is bold.

.PARAMETER ForegroundColor
The foreground color in either hex or RGB format.

.PARAMETER BackgroundColor
The background color in either hex or RGB format.

.PARAMETER TextSize
The font size of the text. Default is 16pt.

.PARAMETER IsBold
Indicates whether the text is bold. Default is $false.

.PARAMETER ColorFormat
The format of the colors provided. It can be "RGB" or "Hex". Default is "Hex".

.EXAMPLE
Test-WCAGContrast -ForegroundColor "#FFFFFF" -BackgroundColor "#000000" -TextSize 18 -IsBold $true
This example tests the contrast ratio between white (#FFFFFF) and black (#000000), checking if it complies with WCAG guidelines for large, bold text.

.NOTES
Author: Azuremy
Date: 2025-10-08
#>
function Test-WCAGContrast {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ForegroundColor,

        [Parameter(Mandatory = $true)]
        [string]$BackgroundColor,

        [int]$TextSize = 16,
        [bool]$IsBold = $false,

        [ValidateSet("RGB", "Hex")]
        [string]$ColorFormat = "Hex"
    )

    try {
        # Change color according to the format
        if ($ColorFormat -eq "Hex") {
            $fgRGB = ConvertFrom-HexColor -HexColor $ForegroundColor
            $bgRGB = ConvertFrom-HexColor -HexColor $BackgroundColor
        }
        else {
            $fgRGB = $ForegroundColor -split ',' | ForEach-Object { [int]$_ }
            $bgRGB = $BackgroundColor -split ',' | ForEach-Object { [int]$_ }
        }

        # Calculate contrast
        $contrast = Get-ContrastRatio -Color1 $fgRGB -Color2 $bgRGB

        # Determine WCAG compliance
        $compliance = Test-WCAGComliance -ContrastRatio $contrast -TextSize $TextSize -IsBold $IsBold

        return [PSCustomObject]@{
            ForegroundColor = $ForegroundColor
            BackgroundColor = $BackgroundColor
            ContrastRatio   = $contrast
            WCAGLevel       = $compliance
            TextSize        = $TextSize
            IsBold          = $IsBold
            IsLargeText     = ($TextSize -ge 18) -or ($TextSize -ge 14 -and $IsBold)
        }
    }
    catch {
        <#Do this if a terminating exception happens#>
        Write-Error "Error processing colors: $_"
        return $null
    }
}

# Main function to expose
function WCAG-Contrast {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ForegroundColor,

        [Parameter(Mandatory = $true)]
        [string]$BackgroundColor,

        [int]$TextSize = 16,
        [bool]$IsBold = $false,

        [ValidateSet("RGB", "Hex")]
        [string]$ColorFormat = "Hex"
    )

    $result = Test-WCAGContrast -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -TextSize $TextSize -IsBold $IsBold -ColorFormat $ColorFormat

    Write-Host $($result.ContrastRatio):1 - $($result.WCAGLevel) "($($result.ForegroundColor) on $($result.BackgroundColor), Text Size: $($result.TextSize)px, Bold: $($result.IsBold))"
}

Export-ModuleMember -Function WCAG-Contrast