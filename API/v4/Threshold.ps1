#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-Thresholds {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TestID,

        [string]
        $Token = $global:TokenUser
    )
    try {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $requestData = Invoke-WebRequest `
            -Uri "$Global:BASEURI/$apiVersion/tests/$TestID/thresholds" `
            -Headers $AuthHeaders `
            -ContentType 'application/json' `
            -TimeoutSec 10 `
            -DisableKeepAlive `
            -PassThru `
            -OutFile 'Results\APILogs\Get-Thresholds.log' `
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

function New-Threshold{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: New-Threshold
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
    end {
        Write-Verbose "[URI]"
    }
}

function Remove-Threshold{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Remove-Threshold
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
    end {
        Write-Verbose "[URI]"
    }
}

function Edit-Threshold{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO:Edit-Threshold
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
    end {
        Write-Verbose "[URI]"
    }
}
