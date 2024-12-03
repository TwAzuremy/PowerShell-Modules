<#
.SYNOPSIS
    使用记事本打开 hosts 文件。

.DESCRIPTION
    -Hosts 函数用于使用记事本打开位于 $env:windir\System32\drivers\etc\hosts 的 hosts 文件。

.PARAMETER None
    此函数没有任何参数。

.EXAMPLE
    PS C:\> Open-Hosts
    此示例在记事本中打开 hosts 文件。

.NOTES
    作者: Azuremy
    日期: 2023-07-05
#>

function Open-Hosts {
    notepad $env:windir\System32\drivers\etc\hosts
}

Export-ModuleMember -Function Open-Hosts