#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -WarningAction SilentlyContinue

#TODO: I skipped dates for the sake of time and completing basic requests. Need to add them

function Get-AppExecution{
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $UserSessionID,
        $Count='1',

        [string]
        $from,
        $to,
        $Offset,

        [ValidateSet('ascending', 'descending')]
        $Direction='ascending',

        [ValidateSet('true', 'false')]
        $includeTotalCount='false',

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = "direction=$direction&includeTotalCount=$includeTotalCount"
    }
    process{
        try{
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunID/user-sessions/$UserSessionID/app-executions?count=$count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-AppExecution.log'

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

    }
}

function Get-Events{
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $From,
        $To,

        [ValidateSet('ascending', 'descending')]
        $Direction='ascending',

        $Count='1',
        $OffSet,

        [ValidateSet('true', 'false')]
        $includeTotalCount = 'false',

        [ValidateSet('none', 'properties', 'all')]
        $Include='all',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = "direction=$direction&include=$include"
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunId/events?count=$count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Events.log'

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

    }
}

function Get-AppExecutionEvents{
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $AppExecutionID,

        [ValidateSet('ascending', 'descending')]
        $Direction = 'ascending',

        $Count='1',
        $Offset,

        [ValidateSet('true', 'false')]
        $includeTotalCount = 'false',

        [ValidateSet('none', 'properties', 'all')]
        $Include = 'all',

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $params = "direction=$direction&includeTotalCount=$IncludeTotalCount&include=$include"
    }
    process{
        try{
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunID/app-executions/$AppExecutionID/events?count=$Count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-AppExecutionEvents.log'

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

    }
}

function Get-UserSessionEvents {
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $UserSessionID,
        $Offset,

        [ValidateSet('ascending', 'descending')]
        $Direction = 'ascending',

        [ValidateSet('true', 'false')]
        $includeTotalCount = 'false',

        [ValidateSet('none', 'properties', 'all')]
        $Include = 'all',

        $Count = '1',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $params = "direction=$direction&includeTotalCount=$IncludeTotalCount&include=$include"
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunID/user-sessions/$UserSessionID/events?count=$count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-UserSessionEvents.log'

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

    }
}

function Get-EventsID{
    [CmdletBinding()]
    param (
        [string]
        $EventID,

        [ValidateSet('none', 'properties', 'all')]
        $Include = 'all',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/events/$EventID?include=$Include" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-EventsID.log'

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

    }
}

function Get-Measurement{
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $OffSet,

        [ValidateSet('ascending', 'descending')]
        $Direction = 'ascending',

        [ValidateSet('true', 'false')]
        $includeTotalCount = 'false',

        [ValidateSet('none', 'properties', 'all')]
        $Include = 'all',

        $Count = '1',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $params = "direction=$direction&includeTotalCount=$includeTotalCount&include=$include"
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunID/measurements?count=$count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Measurement.log'

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

    }
}

function Get-AppMeasurements{
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $AppExectionID,
        $OffSet,

        [ValidateSet('ascending', 'descending')]
        $Direction = 'ascending',

        [ValidateSet('true', 'false')]
        $includeTotalCount = 'false',

        [ValidateSet('sessionMeasurements', 'applicationmeasurement', 'all')]
        $Include = 'all',

        $Count='1',
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $params = "direction=$direction&includeTotalCount=$includeTotalCount&include=$include"
    }
    process{
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunID/app-executions/$AppExecutionID/measurements?count=$count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-AppMeasurements.log'

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

    }
}

function Get-UserSessionMeasurements{
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $AppExectionID,
        $OffSet,

        [ValidateSet('ascending', 'descending')]
        $Direction = 'ascending',

        [ValidateSet('true', 'false')]
        $includeTotalCount = 'false',

        [ValidateSet('sessionMeasurements', 'applicationmeasurement', 'all')]
        $Include = 'all',

        $Count = '1',
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $params = "direction=$direction&includeTotalCount=$includeTotalCount&include=$include"
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunID/user-sessions/$UserSessionID/measurements?count=$count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-UserSessionMeasurements.log'

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

    }
}

function Get-Report{
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunID/reports" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Report.log'

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

    }
}

function Get-ReportID{
    [CmdletBinding()]
    param (
        [string]
        $ReportId,
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/reports/$reportID" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-ReportID.log'

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

    }
}

function Get-ReportConfigs{
    [CmdletBinding()]
    param (
        [string]
        $TestId,
        $ConfigurationID,

        [ValidateSet('ascending', 'descending')]
        $Direction = 'ascending',

        [ValidateSet('true', 'false')]
        $includeTotalCount = 'false',

        $Count = '1',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $params = "direction=$direction&includeTotalCount=$includeTotalCount"
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/tests/$testId/report-configurations/$configurationID/reports?coun=$count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-ReportConfigs.log'

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

    }
}

function Get-ScreenShot{
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $EventID,
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/$TestRunID/events/$EventID/screenshots" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-ScreenShot.log'

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

    }
}

function Get-ScreenshotAppExecution {
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $AppExectionID,
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/$TestRunId/app-executions/$AppExectionID/screenshots" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-ScreenshotAppExecution.log'

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

    }
}

function Get-ScreenshotAppExecutionID{
    [CmdletBinding()]
    param (
        [string]
        $TestRunID,
        $EventID,
        $ScreenshotID,
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/$TestRunId/app-executions/$AppExectionID/screenshots/$ScreenshotID" `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-ScreenshotAppExecutionID.log'

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

    }
}

function Get-TestRuns{
    [CmdletBinding()]
    param (
        [string]
        $TestId,
        $OffSet,

        [ValidateSet('ascending', 'descending')]
        $Direction = 'ascending',

        [ValidateSet('true', 'false')]
        $includeTotalCount = 'false',

        [ValidateSet('none', 'properties', 'all')]
        $Include = 'all',

        $Count = '1',
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $params = "direction=$direction&includeTotalCount=$includeTotalCount&include=$include"
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/tests/$TestId/test-runs?count=$count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-TestRuns.log'

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

    }
}

function Get-TestRunsID{
    [CmdletBinding()]
    param (
        [string]
        $TestRunId,
        [ValidateSet('none', 'properties', 'all')]
        $Include = 'all',
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunId" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-TestRunsID.log'

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

    }
}

function Get-UserSessions{
    [CmdletBinding()]
    param (
        [string]
        $TestRunId,
        $From,
        $To,
        $OffSet,

        [ValidateSet('ascending', 'descending')]
        $Direction = 'ascending',

        [ValidateSet('true', 'false')]
        $includeTotalCount = 'false',

        [ValidateSet('sessionMeasurements', 'applicationmeasurement', 'all')]
        $Include = 'all',

        $Count = '1',
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
        $params = "direction=$direction&includeTotalcount=$includeTotalCount&include=$include"
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunId/user-sessions?count=$count&$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-UserSessions.log'

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

    }
}

function Get-UserSessionsID {
    [CmdletBinding()]
    param (
        [string]
        $UserSessionID,
        $TestRunId,
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/test-runs/$TestRunId/user-sessions/$UserSessionID" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Method GET `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-UserSessionsID.log'

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

    }
}
