#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-AccountGroups {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $false)]
        [string]
        $Count = "1",

        [ValidateSet('none', 'All', 'members')]
        [string]
        $include,

        [ValidateSet('true', 'false')]
        [string]
        $includeTotalCount,

        [Parameter(mandatory = $false)]
        [ValidateSet('ascending', 'descending')]
        [string]
        $Direction = 'descending',

        [Parameter(mandatory = $false)]
        [ValidateSet('name', 'memberCount', 'description', 'groupType')]
        [string]
        $OrderBy = 'name',

        [string]
        $Token = $global:TokenUser
    )

    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = "orderBy=$OrderBy&direction=$Direction&count=$Count"

        if ($include) {
            $params += "&include=$include"
        }
        if ($includeTotalCount) {
            $params += "&includeTotalCount=$includeTotalCount"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/account-groups?$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-AccountGroups.log' `
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
        Write-Output "[URI] $Global:BASEURI/$apiVersion/account-groups?$params"
    }
}

function Get-AccountGroupId {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [ValidateSet('none', 'all', 'members')]
        [string]
        $Include,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        if($Include -ne ""){
            $params += "?include=$include"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/account-groups/$GroupID$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-AccountGroupId.log' `
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

function New-AccountGroup {
    [CmdletBinding()]
    param (
        [ValidateSet('Selection', 'Filter')]
        [string]
        $GroupType = 'Filter',

        [string]
        $GroupName='foogroup',
        $Description='foodesc',
        $FCondition = "*2*",

        [System.Array]
        $MemberIDs,

        [string]
        $Token = $global:TokenUser
    )

    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if($MemberIDs.Count -gt 1){
            $MemIDs = ($MemberIDs | ConvertTo-Json)
        }else {
            $IDs = ($MemberIDs | ConvertTo-Json)
            $MemIDs = "[`n
                    `n $IDs
            `n]"
        }

        if ($GroupType -eq 'Selection') {
            $body = "{
            `n    '`$type'       :`"Selection`",
            `n    `"name`": `"$GroupName`",
            `n    `"description`": `"$Description`",
            `n    `"Memberids`": $MemIDs
            `n}"
        }else{
            $body = "{
            `n    '`$type'       :`"Filter`",
            `n    `"name`": `"$GroupName`",
            `n    `"description`": `"$Description`",
            `n    `"Condition`": `"$FCondition`"
            `n}"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/account-groups" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\New-AccountGroup.log' `
                -Method POST

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/account-groups"
    }
}

function Edit-AccountGroup {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $GroupID,

        [ValidateSet('Selection', 'Filter')]
        [string]
        $GroupType,

        [string]
        $newName = "EditFoo",
        $NewDescription='FooEdit',
        $NewCondition="*3*",

        [System.Array]
        $MemberIDs = @(),

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($MemberIDs.Count -gt 1) {
            $MemIDs = ($MemberIDs | ConvertTo-Json)
        }else{
            $IDs = ($MemberIDs | ConvertTo-Json)
            $MemIDs = "[`n
                    `n $IDs
            `n]"
        }

        if ($GroupType -eq 'Selection') {
            $body = "{
            `n    '`$type'       :`"Selection`",
            `n    `"name`": `"$newName`",
            `n    `"description`": `"$NewDescription`",
            `n    `"Memberids`": $MemIDs
            `n}"

        }else {
            $body = "{
            `n    '`$type'       :`"Filter`",
            `n    `"name`": `"$newName`",
            `n    `"description`": `"$NewDescription`",
            `n    `"Condition`": `"$NewCondition`"
            `n}"
        }
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/account-groups/$GroupID" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Edit-AccountGroup.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/account-groups/$GroupID"
    }
}

function Remove-AccountGroups {
    [CmdletBinding()]
    param (
        [System.Array]
        $GroupIDs,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($GroupIDs.Count -gt 1) {
            $r = ($GroupIDs | ConvertTo-Json)
            $body = "`n
                    `n $r
            `n "
        }
        else {
            $r = ($GroupIDs | ConvertTo-Json)
            $body = "[`n
                    `n $r
            `n]"
        }
    }
    process{
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/account-groups" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-AccountGroups.log' `
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
    }end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/account-groups"
    }
}

function Remove-AccountGroupID {
    [CmdletBinding()]
    param (
        [string]
        $GroupID,

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/account-groups/$GroupID" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-AccountGroupID.log' `
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
    }end {
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/account-groups/$GroupID"
    }
}
