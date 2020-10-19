#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-Workload {
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

        $params = "$TestID/workload"

        $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$params" `
            -Headers $AuthHeaders `
            -ContentType 'application/json' `
            -TimeoutSec 10 `
            -DisableKeepAlive `
            -PassThru `
            -OutFile 'Results\APILogs\Get-Workload.log' `
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

function Add-Workload{
    [CmdletBinding()]
    param (
        [string]
        $ApplicationID,

        [ValidateSet('AppInvocation', 'Delay')]
        [string]
        $TestType = 'AppInvocation',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: New-Workload
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

function Edit-Workload{
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
            #TODO: Edit-Workload
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

function Remove-Workload{
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
            #TODO: Remove-Workload
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

function Remove-WorkloadStep{
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
            #TODO:Remove-WorkloadStep
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

function Edit-WorkloadStep{
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
            #TODO:Edit-WorkloadStep
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
