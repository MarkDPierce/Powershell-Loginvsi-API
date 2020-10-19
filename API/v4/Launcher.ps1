#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-Launchers {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $false)]
        [ValidateSet('name')]
        [string]
        $OrderBy = 'name',

        [Parameter(mandatory = $false)]
        [ValidateSet('ascending', 'descending')]
        [string]
        $Direction = 'descending',

        [Parameter(mandatory = $false)]
        [string]
        $count = "1",

        [ValidateSet('true', 'false')]
        [string]
        $includeTotalCount,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = "orderBy=$OrderBy&direction=$Direction&count=$count"

        if ($includeTotalCount) {
            $params += "&includeTotalCount=$includeTotalCount"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/launchers?$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Launchers.log' `
                -Method GET

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode = [int]$_.Exception.Response.StatusCode
                response   = $_.Exception.Response
                baseURI    = $_.Exception.Response.ResponseUri
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launchers?$params"
    }
}

function Get-LaunchersName {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $LauncherName,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/launchers/$LauncherName" `
                -Headers $AuthHeaders `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-LaunchersName.log'

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode   = [int]$_.Exception.Response.StatusCode
                response     = $_.Exception.Response
                baseURI      = $_.Exception.Response.ResponseUri
                LauncherName = $LauncherName
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launchers/$LauncherName"
    }
}
