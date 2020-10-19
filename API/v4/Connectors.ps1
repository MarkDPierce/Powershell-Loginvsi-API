#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-Connectors {
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
        $Count = "1",

        [Parameter(mandatory = $false)]
        [ValidateSet('none', 'parameter', 'all')]
        [string]
        $includeOptions = 'none',

        [ValidateSet('true', 'false')]
        [string]
        $includeTotalCount,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = "include=$includeOptions&orderBy=$OrderBy&direction=$Direction&count=$count"

        if ($includeTotalCount) {
            $params += "&includeTotalCount=$includeTotalCount"
        }
    }
    process{
        try{
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/connectors?$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Connectors.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/connectors?$params"
    }
}

function Get-ConnectorsID {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $connectorId,

        [Parameter(mandatory = $false)]
        [ValidateSet('all', 'none', 'parameter')]
        [string]
        $IncludeOptions = 'none',

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params += "?includeOptions=$IncludeOptions"
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/connectors/$connectorId$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-ConnectorsID.log' `
                -Method GET

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode  = [int]$_.Exception.Response.StatusCode
                response    = $_.Exception.Response
                baseURI     = $_.Exception.Response.ResponseUri
                connectorId = $connectorId
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/connectors/$connectorId$params"
    }
}
