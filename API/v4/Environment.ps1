#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue


function Edit-Environment{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $body = ''
    }
    process{
        try {
            #TODO: Create Edit-Environment
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$TestID/environment" `
                -Body $body `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Edit-Environment.log' `
                -Method PUT

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode = [int]$_.Exception.Response.StatusCode
                response   = $_.Exception.Response
                baseURI    = $_.Exception.Response.ResponseUri
                testID     = $TestID
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI]"
    }
}
function Get-Environment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TestID,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$TestID/environment" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Environment.log' `
                -Method GET

            return $requestData
            Write-Output "[URI] $Global:BASEURI/$apiVersion/tests/$params"
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode = [int]$_.Exception.Response.StatusCode
                response   = $_.Exception.Response
                baseURI    = $_.Exception.Response.ResponseUri
                testID     = $TestID
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/tests/$TestID/environment"
    }
}
