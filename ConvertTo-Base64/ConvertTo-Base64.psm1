<#
.SYNOPSIS
    对输入的字符串进行 Base64 编码或解码。

.DESCRIPTION
    该函数 `ConvertTo-Base64` 提供两种模式：编码和解码。可以根据参数的不同，进行 Base64 编码或解码的操作。
    - 编码模式：将输入字符串转为 Base64 编码。
    - 解码模式：将输入的 Base64 编码字符串还原为原始字符串。

.PARAMETER e
    "Encode" 首字母，指定编码模式。如果该参数被提供，则函数会将输入字符串进行 Base64 编码。

.PARAMETER d
    "Decode" 首字母，指定解码模式。如果该参数被提供，则函数会将输入的 Base64 字符串解码为原始字符串。

.PARAMETER InputString
    输入的字符串，作为 Base64 编码或解码的目标。此参数必须为字符串类型。

.EXAMPLE
    ConvertTo-Base64 -e -InputString "Hello, World!"
    将字符串 "Hello, World!" 编码为 Base64 格式并输出。

    ConvertTo-Base64 -d -InputString "SGVsbG8sIFdvcmxkIQ=="
    将 Base64 字符串 "SGVsbG8sIFdvcmxkIQ==" 解码为 "Hello, World!"。

.NOTES
    作者: Azuremy
    创建日期: 2023-10-26
#>

function ConvertTo-Base64 {
    [CmdletBinding(DefaultParameterSetName = 'Encode')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Encode')]
        [Alias('e')]
        [switch]$Encode,
        
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Decode')]
        [Alias('d')]
        [switch]$Decode,
        
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
        [string]$InputString
    )
    process {
        if ($Encode) {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
            $base64 = [System.Convert]::ToBase64String($bytes)
            Write-Output $base64
        }
        elseif ($Decode) {
            $bytes = [System.Convert]::FromBase64String($InputString)
            $decodedString = [System.Text.Encoding]::UTF8.GetString($bytes)
            Write-Output $decodedString
        }
    }
}