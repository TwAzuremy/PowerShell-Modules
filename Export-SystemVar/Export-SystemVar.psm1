<#
.SYNOPSIS
    导出当前系统的环境变量到指定文件路径。

.DESCRIPTION
    该函数 `Export-SystemVar` 用于将系统中所有的环境变量输出到指定的文件路径。
    如果指定的路径不存在，该函数会自动创建缺失的文件夹。默认情况下，输出的文件会被保存在当前用户的桌面上，
    文件名为 `SystemVariables.txt`。

.PARAMETER path
    指定要保存环境变量的文件路径。默认值为当前用户桌面上的 `SystemVariables.txt`。

    示例:
    - `$path = "C:\MyFolder\EnvVars.txt"`

.EXAMPLE
    Export-SystemVar -path "C:\MyFolder\EnvVars.txt"
    导出系统环境变量并保存到 `C:\MyFolder\EnvVars.txt`。

    Export-SystemVar
    导出系统环境变量并保存到默认路径 `$home\Desktop\SystemVariables.txt`。

.NOTES
    作者: Azuremy
    创建日期: 2024-03-06
#>

function Export-SystemVar {
    param (
        [string] $path = "$home\Desktop\SystemVariables.txt"
    )

    if (-not (Test-Path (Split-Path $path))) {
        New-Item -ItemType Directory -Path (Split-Path $path) | Out-Null
    }

    Get-ChildItem Env: | Out-File $path
}

Export-ModuleMember -Function Export-SystemVar