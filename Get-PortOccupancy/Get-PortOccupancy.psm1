<#
.SYNOPSIS
    获取指定端口是否被占用，并显示占用该端口的应用程序信息。

.DESCRIPTION
    此函数用于检查指定的端口是否被占用，并返回占用该端口的应用程序的相关信息。

.PARAMETER Port
    要检查的端口号。

.EXAMPLE
    Get-PortOccupancy -Port 8080
    Get-PortOccupancy -Port 443

.NOTES
    作者: Azuremy
    创建日期: 2023-07-02
#>

function Get-PortOccupancy {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [int]
        $Port
    )

    $ErrorActionPreference = "Stop"

    try {
        $result = Get-NetTCPConnection | Where-Object {
            $_.LocalPort -eq $Port -and $_.State -eq "Listen"
        }

        if ($result) {
            $processes = $result | ForEach-Object {
                Get-Process -Id $_.OwningProcess
            }

            Write-Output "The following applications are using port $Port :"
            $processes | Select-Object Name, Id, Path | Format-Table -AutoSize
        }
        else {
            Write-Output "Port $Port is not occupied."
        }
    }
    catch {
        <#Do this if a terminating exception happens#>
        Write-Output "An error occurred while querying port occupancy: $($_.Exception.Message)"
    }
}

Export-ModuleMember -Function Get-PortOccupancy