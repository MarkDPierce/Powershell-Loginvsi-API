#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -WarningAction SilentlyContinue
function Get-Accounts{
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $false)]
        [string]
        $Count="1",

        [Parameter(mandatory = $false)]
        [ValidateSet('ascending', 'descending')]
        [string]
        $Direction = 'descending',

        [Parameter(mandatory = $false)]
        [ValidateSet('username', 'domain', 'locked', 'enabled')]
        [string]
        $OrderBy = 'username',

        [ValidateSet('true', 'false')]
        [string]
        $includeTotalCount,

        [string]
        $Token = $global:TokenUser

    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = "orderBy=$OrderBy&direction=$Direction&count=$Count"

        if ($includeTotalCount) {
            $params += "&includeTotalCount=$includeTotalCount"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest `
                -Uri "$Global:BASEURI/$apiVersion/accounts?$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Accounts.log' `
                -Method GET

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode = [int]$_.Exception.Response.StatusCode
                response   = $_.Exception.Response
                baseURI    = $_.Exception.Response.ResponseUri
                AccountID  = $AccountID
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/accounts?$params"
    }
}

function Get-AccountID {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $AccountID,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $params = $AccountID
    }
    process{
        try {
            $requestData = Invoke-WebRequest `
                -Uri "$Global:BASEURI/$apiVersion/accounts/$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-AccountID.log' `
                -Method GET

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode = [int]$_.Exception.Response.StatusCode
                response   = $_.Exception.Response
                baseURI    = $_.Exception.Response.ResponseUri
                AccountID  = $AccountID
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/accounts/$params"
    }
}

function New-Accounts{
    [CmdletBinding()]
    param (
        [string]
        $UserName,

        [string]
        $Domain,

        [string]
        $Pass,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $body = "{
        `n    `"username`":  `"$UserName`",
        `n    `"domainId`":  `"$Domain`",
        `n    `"password`":  `"$Pass`"
        `n}"
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/accounts" `
                -Headers $AuthHeaders `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\New-Accounts.log' `
                -Method POST

            return $requestData
        }
        catch [System.Net.WebException] {
            $errObj = [PSCustomObject]@{
                statuscode = [int]$_.Exception.Response.StatusCode
                baseURI    = "[URI] $Global:BASEURI/$apiVersion/accounts"
                exception  = $_.Exception
            }
            return $errObj
        }
        catch {
            Write-Error $_
        }
    }
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/accounts"
    }
}

function Edit-Account{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $AccountID,

        [Parameter(Mandatory = $true)]
        [string]
        $NewUserName,

        [string]
        $Newdomain,

        [string]
        $NewPass,

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $body = @{
            "passwordHasChanged"= "true";
            "username"           = "$NewUserName";
            "domainId"           = "$Newdomain";
            "password"           = "$NewPass"
        }
    }
    process {
        try {

            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/accounts/$AccountID" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Edit-Account.log' `
                -Body ($body | ConvertTo-Json) `
                -Method PUT

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/accounts/$AccountID"
    }
}

function Set-EnabledAccount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $AccountID,

        [Parameter(Mandatory = $true)]
        [ValidateSet('true', 'false')]
        [string]
        $Enabled,

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/accounts/$AccountID/enabled" `
                -Headers $AuthHeaders `
                -Body ($Enabled|convertto-json) `
                -Method PUT `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Set-EnabledAccount.log' `
                -ContentType "application/json"

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/accounts/$AccountID"
    }
}

function Remove-Accounts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]
        $RequestBody,

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($RequestBody.Count -gt 1) {
            $r = ($RequestBody | ConvertTo-Json)
            $body = "`n
                    `n $r
            `n "
        }else {
            $r = ($RequestBody | ConvertTo-Json)
            $body = "[`n
                    `n $r
            `n]"
        }
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/accounts" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-Accounts.log' `
                -Body $body `
                -Method Delete

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/accounts"
    }
}

function Remove-AccountID{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $AccountID,

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-WebRequest `
                -Uri "$Global:BASEURI/$apiVersion/accounts/$AccountID" `
                -Headers $AuthHeaders `
                -Method DELETE `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-AccountID.log' `

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/accounts/$AccountID"
    }
}
