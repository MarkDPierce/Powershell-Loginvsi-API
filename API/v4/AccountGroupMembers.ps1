#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -WarningAction SilentlyContinue

function Get-AccountGroupMembers {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [Parameter(mandatory = $false)]
        [ValidateSet('username', 'domain', 'locked', 'enable')]
        [string]
        $OrderBy = 'username',

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

        $c = $count

        $params = "$GroupID/members?orderBy=$OrderBy&direction=$Direction&count=$c"

        if ($includeTotalCount) {
            $params += "&includeTotalCount=$includeTotalCount"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/account-groups/$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-AccountGroupMembers.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/account-groups/$params"
    }
}

function Add-AccountGroupMembers {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupId,

        [System.Array]
        $AccountIDs,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($AccountID.Count -gt 1) {
            $r = ($AccountID | ConvertTo-Json)
            $body = "`n
                    `n $r
            `n "
        }else {
            $r = ($AccountID | ConvertTo-Json)
            $body = "[`n
                    `n $r
            `n]"
        }
    }
    process{
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/account-groups/$GroupId/members" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Body $body `
                -Method POST `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Add-AccountGroupMembers.log'

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/account-groups/$GroupId/members"
    }
}

function Edit-AccountGroupMembers {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [Parameter(mandatory = $true)]
        [string]
        $AccountIDs,

        [string]
        $Token = $global:TokenUser
    )

    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($AccountIDs.Count -gt 1) {
            $r = ($AccountIDs | ConvertTo-Json)
            $body = "`n
                    `n $r
            `n "
        }else {
            $r = ($AccountIDs | ConvertTo-Json)
            $body = "[$r]"
        }
    }
    process {
        try {

            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/account-groups/$GroupId/members" `
                -Headers $AuthHeaders `
                -Body $body `
                -UseBasicParsing `
                -Method PUT `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Edit-AccountGroupMembers.log'

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
    end {
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/account-groups/$GroupId/members"
    }
}

function Remove-AccountGroupMember {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [Parameter(mandatory = $true)]
        [System.Array]
        $AccountIDs,

        [string]
        $Token = $global:TokenUser
    )

    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($AccountIDs.Count -gt 1) {
            $r = ($AccountIDs | ConvertTo-Json)
            $body = "`n
                    `n $r
            `n "
        }else {
            $r = ($AccountIDs | ConvertTo-Json)
            $body = "[`n
                    `n $r
            `n]"
        }
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/account-groups/$GroupId/members" `
                -Headers $AuthHeaders `
                -Body $body `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-AccountGroupMember.log' `
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
    end {
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/account-groups/$GroupId/members"
    }
}
