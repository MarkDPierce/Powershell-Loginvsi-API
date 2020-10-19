 #Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-Script {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $ApplicationID,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/applications/$ApplicationID/script" `
                -UseBasicParsing `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Script.log' `
                -Method GET

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode    = [int]$_.Exception.Response.StatusCode
                response      = $_.Exception.Response
                baseURI       = $_.Exception.Response.ResponseUri
                ApplicationID = $ApplicationID
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/applications/$ApplicationID"
    }
}

function Get-ScriptStatus {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $ApplicationID,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/applications/$ApplicationID/script/status" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-ScriptStatus.log' `
                -Method GET

            return $requestData

        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode    = [int]$_.Exception.Response.StatusCode
                response      = $_.Exception.Response
                baseURI       = $_.Exception.Response.ResponseUri
                ApplicationID = $ApplicationID
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/applications/$ApplicationID/script/status"
    }
}
function Add-Script{
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $ApplicationID,

        [string]
        $ScriptContent,

        [string]
        $Token = $global:TokenUser
    )

    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        #$AuthHeaders.Add("Accept-Encoding", "gzip, deflate, br")
        $AuthHeaders.Add("Content-Type", "text/plain")

        $body = $ScriptContent
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/applications/$ApplicationID/script" `
                -UseBasicParsing `
                -Headers $AuthHeaders `
                -PassThru `
                -OutFile './Logs/Add-Script.log' `
                -Body $body `
                -Method POST

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode    = [int]$_.Exception.Response.StatusCode
                response      = $_.Exception.Response
                baseURI       = $_.Exception.Response.ResponseUri
                ApplicationID = $ApplicationID
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/applications/$ApplicationID/script"
    }
}
