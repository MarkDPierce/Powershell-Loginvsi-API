#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue
function Get-LauncherGroups {
    [CmdletBinding()]
    param (
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
        $Count = "1",

        [ValidateSet('true', 'false')]
        [string]
        $includeTotalCount,

        [ValidateSet('all', 'none', 'members')]
        [string]
        $IncludeOptions,

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
        if ($IncludeOptions) {
            $params += "&includeOptions=$IncludeOptions"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/launcher-groups?$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-LauncherGroups.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launcher-groups?$params"
    }
}
function Get-LauncherGroupsID {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [ValidateSet('all', 'none', 'members')]
        [string]
        $IncludeOptions,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = ""
        if ($IncludeOptions) {
            $params += "?includeOptions=$IncludeOptions"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/launcher-groups/$GroupID$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-LauncherGroupsID.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launcher-groups/$GroupID"
    }

}

function New-LauncherGroup {
    [CmdletBinding()]
    param (
        [validateset('Selection', 'Filter')]
        [string]
        $GroupType,

        [string]
        $GroupName='foogroup',
        $Description = $GroupName,
        $FilterCondition = "*2*",

        [system.array]
        $LauncherNames,

        [string]
        $Token = $global:TokenUser
    )

    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($LauncherNames.Count -gt 1) {
            $Lids = ($LauncherNames | ConvertTo-Json)
        }else {
            $IDs = ($LauncherNames | ConvertTo-Json)
            $Lids = "[`n
                    `n $IDs
            `n]"
        }

        if ($GroupType -eq "Selection"){
            $body = "{
            `n    '`$type': `"Selection`",
            `n    `"name`": `"$GroupName`",
            `n    `"description`": `"$Description`",
            `n    `"LauncherNames`":
            `n        $Lids
            `n    ,
            `n    `"data`": {}
            `n}"
        }else{
            $body = "{
            `n    '`$type': `"Filter`",
            `n    `"name`": `"$GroupName`",
            `n    `"condition`": `"$FilterCondition`",
            `n    `"description`": `"$Description`",
            `n    `"data`": {
            `n
            `n    }
            `n}"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/launcher-groups" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\New-LauncherGroup.log' `
                -Body $body `
                -Method POST

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launcher-groups"
    }
}

function Edit-LauncherGroup {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [validateset('Selection', 'Filter')]
        [string]
        $GroupType,

        [string]
        $GroupName = 'foogroup',
        $Description = 'groupfoo',
        $FilterCondition = "*2*",

        [system.array]
        $LauncherNames,

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($LauncherNames.Count -gt 1) {
            $Lids = ($LauncherNames | ConvertTo-Json)
        }else {
            $IDs = ($LauncherNames | ConvertTo-Json)
            $Lids = "[`n
                    `n $IDs
            `n]"
        }

        if ($GroupType -eq "Selection") {
            $body = "{
            `n    '`$type': `"Selection`",
            `n    `"name`": `"$GroupName`",
            `n    `"description`": `"$Description`",
            `n    `"LauncherNames`":
            `n        $Lids
            `n    ,
            `n    `"data`": {}
            `n}"
        }
        else {
            $body = "{
            `n    '`$type': `"Filter`",
            `n    `"name`": `"$GroupName`",
            `n    `"condition`": `"$FilterCondition`",
            `n    `"description`": `"$Description`",
            `n    `"data`": {
            `n
            `n    }
            `n}"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/launcher-groups/$GroupID" `
                -Headers $AuthHeaders `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Edit-LauncherGroup.log' `
                -Method PUT

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launcher-groups/$GroupID"
    }
}

function Remove-LauncherGroups {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
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
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/launcher-groups" `
                -Headers $AuthHeaders `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-LauncherGroups.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launcher-groups"
    }
}

function Remove-LauncherGroupID {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $GroupID,

        [string]
        $Token = $global:TokenUser
    )
    Begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process{
        try{
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/launcher-groups/$GroupID" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-LauncherGroupID.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/launcher-groups/$GroupID"
    }
}
