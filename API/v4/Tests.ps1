#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false

Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-Tests{
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $false)]
        [ValidateSet('name', 'connector', 'description')]
        [string]
        $OderBy = 'name',

        [Parameter(mandatory = $false)]
        [ValidateSet('ascending', 'descending')]
        [string]
        $Direction = 'ascending',

        [Parameter(mandatory = $false)]
        [string]
        $Count = "1",

        [ValidateSet('true', 'false')]
        [string]
        $includeTotalCount,

        [ValidateSet('none', 'environment', 'worklaod', 'thresholds', 'all')]
        [string]
        $includeOptions,

        [ValidateSet('ApplicationTest', 'loadTest', 'continuousTest')]
        [string]
        $TestType,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = "orderBy=$OderBy&direction=$Direction&count=$Count"

        if ($TestType) {
            $params += "&testType=$TestType"
        }
        if ($include) {
            $params += "&includeOptions=$include"
        }
        if ($includeTotalCount) {
            $params += "&includeTotalCount=$includeTotalCount"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests?$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Tests.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/tests?$params"
    }
}

function Get-TestsID{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TestID,

        [Parameter(mandatory = $true)]
        [ValidateSet('none', 'environment', 'worklaod', 'thresholds', 'all')]
        [string]
        $includeOptions,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = "$TestID"
        if ($includeOptions) {
            $params += "?includeOptions=$includeOptions"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-TestsID.log' `
                -Method GET

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/tests/$params"
    }
}

function Remove-Tests{
    [CmdletBinding()]
    param (
        [System.Array]
        $TestID,

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try{
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/tests/$TestID" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-Tests.log' `
                -Body $body `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/tests/$TestID"
    }
}

function Remove-TestID {
    [CmdletBinding()]
    param (
        [System.Array]
        $TestIDs,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        if ($TestIDs.Count -gt 1) {
            $r = ($TestIDs | ConvertTo-Json)
            $body = "`n
                    `n $r
            `n "
        }else {
            $r = ($TestIDs | ConvertTo-Json)
            $body = "[`n
                    `n $r
            `n]"
        }
    }
    process{
        try{
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/tests" `
                -Headers $AuthHeaders `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-TestID.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/tests"
    }
}

function Start-Test{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TestID,

        [string]
        $TestComment='foo',

        [string]
        $Token = $global:TokenOperator
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $body = "{
`n  `"comment`": `"$TestComment`"
`n}"
    }
    process {
        try {

            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$TestID/start" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -Body $body `
                -PassThru `
                -OutFile 'Results\APILogs\Start-Test.log' `
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
    end {
        Write-Verbose "[TestID] $testID"
        Write-Verbose "[URI]"
    }
}

function Stop-Test{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TestID,

        [string]
        $TestComment = 'foo',

        [string]
        $Token = $global:TokenOperator
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$TestID/stop" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Stop-Test.log' `
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
    end {
        Write-Verbose "[URI]"
    }
}

function Get-Notifications {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TestID,

        [switch]
        $Fparams,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = $null
        if ($Fparams) {
            $params = ""
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$TestID/notifications/$params" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Notifications.log' `
                -Method GET

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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/tests/$TestID/"
    }

}

function New-Test {
    [CmdletBinding()]
    param (
        [ValidateSet('ApplicationTest', 'LoadTest', 'ContinuousTest')]
        [string]
        $TestType = 'ApplicationTest',

        [ValidateSet('rdp', 'NetScaler', 'StoreFront', 'Horizon', 'Desktop', 'custom')]
        [string]
        $connectorId = 'rdp',

        [string]
        $AccountGroups,
        $LauncherGroups,

        [string]
        $TestName,
        $TestDescription = $TestName,
        $TestHost = 'foohost',
        $TestResource='',
        $TestGateway='',
        $TestSuppressCert = 'true',
        $TestDisplayConfiguration = 'fullscreen',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($AccountGroups.Count -gt 1) {
            $r = ($AccountGroups | ConvertTo-Json)
            $ac = "`n
                   `n $r
                `n"
        }else {
            $r = ($LauncherGroups | ConvertTo-Json)
            $ac = "[`n
                    `n $r
            `n]"
        }

        if ($LauncherGroups.Count -gt 1) {
            $r = ($LauncherGroups | ConvertTo-Json)
            $lg = "`n
                   `n $r
                `n"
        }else {
            $r = ($LauncherGroups | ConvertTo-Json)
            $lg = "[`n
                    `n $r
            `n]"
        }

        if ($connectorId -eq 'RDP') {
            $CPV = "[
            `n        {
            `n            `"key`": `"host`",
            `n            `"value`": `"$TestHost`"
            `n        },
            `n        {
            `n            `"key`": `"resource`",
            `n            `"value`": `"$TestResource`"
            `n        },
            `n        {
            `n            `"key`": `"gateway`",
            `n            `"value`": `"$TestGateway`"
            `n        },
            `n        {
            `n            `"key`": `"suppressCertWarn`",
            `n            `"value`": `"$TestSuppressCert`"
            `n        },
            `n        {
            `n            `"key`": `"displayConfiguration`",
            `n            `"value`": `"$TestDisplayConfiguration`"
            `n        }
            `n    ]"
        }
        if ($connectorId -eq 'NetScaler' -or $connectorId -eq 'StoreFront') {
            $CPV = "[
            `n        {
            `n            `"key`": `"serverUrl`",
            `n            `"value`": `"$TestServerUrl`"
            `n        },
            `n        {
            `n            `"key`": `"resource`",
            `n            `"value`": `"$TestResource`"
            `n        },
            `n        {
            `n            `"key`": `"displayConfiguration`",
            `n            `"value`": `"$TestDisplayConfiguration`"
            `n        }
                `n    ]"
        }
        if ($connectorId -eq 'Desktop'){
            $CPV = ""
        }
        if ($connectorId -eq 'custom') {
            $CPV = ""
        }
        if ($connectorId -eq 'Horizon') {
            $CPV = "[
            `n        {
            `n            `"key`": `"serverUrl`",
            `n            `"value`": `"$TestServerUrl`"
            `n        },
            `n        {
            `n            `"key`": `"resource`",
            `n            `"value`": `"$TestResource`"
            `n        },
            `n        {
            `n            `"key`": `"commandLine`",
            `n            `"value`": `"$TestCommandLine`"
            `n        }
            `n    ]"
        }

        $body = "{
        `n    `"`$type`": `"$TestType`",
        `n    `"name`": `"$TestName`",
        `n    `"description`": `"$TestDescription`",
        `n    `"connectorId`": `"$connectorId`",
        `n    `"connectorParameterValues`": $CPV,
        `n    `"accountGroups`": $ac,
        `n    `"launcherGroups`": $lg
        `n}"
    }
    process {
        try {
            $requestData = Invoke-WebRequest -Uri "$BASEURI/$apiVersion/tests" `
                -Body $body `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\New-Test.log' `
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
    end {
        Write-Verbose "[URI] $BASEURI/$apiVersion/tests"
    }
}

#TODO: Edit-Test
function Edit-Test{
    [CmdletBinding()]
    param (
        [ValidateSet('ApplicationTest', 'LoadTest', 'ContinuousTest')]
        [string]
        $TestType = 'ApplicationTest',

        [ValidateSet('rdp', 'NetScaler', 'StoreFront', 'Horizon', 'Desktop', 'custom')]
        [string]
        $connectorId = 'rdp',

        [string]
        $AccountGroups,
        $LauncherGroups,

        [string]
        $TestName,
        $TestDescription = $TestName,
        $TestHost = 'foohost',
        $TestResource = '',
        $TestGateway = '',
        $TestSuppressCert = 'true',
        $TestDisplayConfiguration = 'fullscreen',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($AccountGroups.Count -gt 1) {
            $r = ($AccountGroups | ConvertTo-Json)
            $ac = "`n
                   `n $r
                `n"
        }
        else {
            $r = ($LauncherGroups | ConvertTo-Json)
            $ac = "[`n
                    `n $r
            `n]"
        }

        if ($LauncherGroups.Count -gt 1) {
            $r = ($LauncherGroups | ConvertTo-Json)
            $lg = "`n
                   `n $r
                `n"
        }
        else {
            $r = ($LauncherGroups | ConvertTo-Json)
            $lg = "[`n
                    `n $r
            `n]"
        }

        if ($connectorId -eq 'RDP') {
            $CPV = "[
            `n        {
            `n            `"key`": `"host`",
            `n            `"value`": `"$TestHost`"
            `n        },
            `n        {
            `n            `"key`": `"resource`",
            `n            `"value`": `"$TestResource`"
            `n        },
            `n        {
            `n            `"key`": `"gateway`",
            `n            `"value`": `"$TestGateway`"
            `n        },
            `n        {
            `n            `"key`": `"suppressCertWarn`",
            `n            `"value`": `"$TestSuppressCert`"
            `n        },
            `n        {
            `n            `"key`": `"displayConfiguration`",
            `n            `"value`": `"$TestDisplayConfiguration`"
            `n        }
            `n    ]"
        }
        if ($connectorId -eq 'NetScaler' -or $connectorId -eq 'StoreFront') {
            $CPV = "[
            `n        {
            `n            `"key`": `"serverUrl`",
            `n            `"value`": `"$TestServerUrl`"
            `n        },
            `n        {
            `n            `"key`": `"resource`",
            `n            `"value`": `"$TestResource`"
            `n        },
            `n        {
            `n            `"key`": `"displayConfiguration`",
            `n            `"value`": `"$TestDisplayConfiguration`"
            `n        }
                `n    ]"
        }
        if ($connectorId -eq 'Desktop') {
            $CPV = ""
        }
        if ($connectorId -eq 'custom') {
            $CPV = ""
        }
        if ($connectorId -eq 'Horizon') {
            $CPV = "[
            `n        {
            `n            `"key`": `"serverUrl`",
            `n            `"value`": `"$TestServerUrl`"
            `n        },
            `n        {
            `n            `"key`": `"resource`",
            `n            `"value`": `"$TestResource`"
            `n        },
            `n        {
            `n            `"key`": `"commandLine`",
            `n            `"value`": `"$TestCommandLine`"
            `n        }
            `n    ]"
        }

        $body = "{
        `n    `"`$type`": `"$TestType`",
        `n    `"name`": `"$TestName`",
        `n    `"description`": `"$TestDescription`",
        `n    `"connectorId`": `"$connectorId`",
        `n    `"connectorParameterValues`": $CPV,
        `n    `"accountGroups`": $ac,
        `n    `"launcherGroups`": $lg
        `n}"
    }
    process {
        try {
            $requestData = Invoke-WebRequest -Uri "$BASEURI/$apiVersion/tests" `
                -Body $body `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\New-Test.log' `
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
    end {
        Write-Verbose "[URI] $BASEURI/$apiVersion/tests"
    }
}
