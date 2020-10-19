#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-LauncherGroupMember {
    [CmdletBinding()]
    param (

        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [Parameter(mandatory = $false)]
        [ValidateSet('name', 'membercount', 'description', 'grouptype')]
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

        $params = "members?orderBy=$OrderBy&direction=$Direction&count=$count"

        if ($includeTotalCount) {
            $params += "&includeTotalCount=$includeTotalCount"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/launcher-groups/$GroupID/$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-LauncherGroupMember.log' `
                -Method GET

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode = [int]$_.Exception.Response.StatusCode
                response   = $_.Exception.Response
                baseURI    = $_.Exception.Response.ResponseUri
                GroupID    = $GroupID
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launcher-groups/$GroupID/$params"
    }
}

function Add-LauncherGroupMember {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [Parameter(mandatory = $true)]
        [System.Array]
        $LauncherNames,

        [string]
        $Token = $global:TokenUser
    )

    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($LauncherNames.Count -gt 1) {
            $r = ($LauncherNames | ConvertTo-Json)
            $body = "`n
                    `n $r
            `n "
        }else {
            $r = ($LauncherNames | ConvertTo-Json)
            $body = "[`n
                    `n $r
            `n]"
        }
    }
    process{
        try{
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/launcher-groups/$GroupId/members" `
                -Headers $AuthHeaders `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Add-LauncherGroupMember.log' `
                -Method POST

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode = [int]$_.Exception.Response.StatusCode
                response   = $_.Exception.Response
                baseURI    = $_.Exception.Response.ResponseUri
                GroupID    = $GroupID
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launcher-groups/$GroupId/members"
    }
}

function Remove-LauncherGroupMember{
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [Parameter(mandatory = $true)]
        [System.Array]
        $LauncherNames,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($LauncherNames.Count -gt 1) {
            $r = ($LauncherNames | ConvertTo-Json)
            $body = "`n
                    `n $r
            `n "
        }
        else {
            $r = ($LauncherNames | ConvertTo-Json)
            $body = "[`n
                    `n $r
            `n]"
        }
    }
    process{
        try{
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/launcher-groups/$GroupId/members" `
                -Headers $AuthHeaders `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-LauncherGroupMember.log' `
                -Method DELETE

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launcher-groups/$GroupId/members"
    }
}
