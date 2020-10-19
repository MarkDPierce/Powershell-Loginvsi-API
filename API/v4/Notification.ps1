#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-Notifications{
    [CmdletBinding()]
    param (
        [string]
        $TestID,

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {

            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$TestID /notifications" `
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
    end {
        Write-Verbose "[URI]"
    }
}

function Add-Notifications{
    [CmdletBinding()]
    param (
        [string]
        $TestID = $Script:TestID,
        $ApplicationID = $script:ApplicationWinId,

        [ValidateSet('Threshold', 'Event')]
        [string]
        $NotificationType,

        $Timer='string',
        $ThresholdValue = '1',
        $TimesExceeded = '1',
        $PeriodDuration = '1',

        [ValidateSet('true', 'false')]
        [string]
        $ThresholdIsEnabled='false',

        [ValidateSet('true', 'false')]
        [string]
        $NotificationisEnabled = 'true',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($NotificationType -eq 'Threshold'){
            $body = "{
        `n    '`$type': `"Threshold`",
        `n    `"threshold`": {
        `n        `"applicationId`": `"$ApplicationID`",
        `n        `"timer`": `"$Timer`",
        `n        `"isEnabled`": $ThresholdIsEnabled,
        `n        `"value`": $ThresholdValue
        `n    },
        `n    `"timesExceeded`": $TimesExceeded,
        `n    `"periodDuration`": $PeriodDuration,
        `n    `"isEnabled`": $NotificationisEnabled
        `n}"
        }else{
            $body = "{
        `n    '`$type': `"Event`",
        `n    `"threshold`": {
        `n        `"applicationId`": `"$ApplicationID`",
        `n        `"timer`": `"$Timer`",
        `n        `"isEnabled`": $ThresholdIsEnabled,
        `n        `"value`": $ThresholdValue
        `n    },
        `n    `"timesExceeded`": $TimesExceeded,
        `n    `"periodDuration`": $PeriodDuration,
        `n    `"isEnabled`": $NotificationisEnabled
        `n}"
        }
    }
    process {
        try {

            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$TestID/notifications" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -Body $body `
                -OutFile 'Results\APILogs\Add-Notifications.log' `
                -Method POST

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

function Edit-Notification{
    [CmdletBinding()]
    param (
        [string]
        $TestID = $Script:TestID,
        $NotificationID,

        [ValidateSet('Threshold', 'Event')]
        [string]
        $NotificationType,

        $ThresholdValue = '1',
        $TimesExceeded = '1',
        $PeriodDuration = '1',

        [ValidateSet('true', 'false')]
        [string]
        $ThresholdIsEnabled = 'false',

        [ValidateSet('true', 'false')]
        [string]
        $NotificationisEnabled = 'true',

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($NotificationType -eq 'Threshold') {
            $body = "{
        `n    '`$type': `"Threshold`",
        `n    `"thresholdUpdate`": {
        `n        `"isEnabled`": $ThresholdIsEnabled,
        `n        `"value`": $ThresholdValue
        `n    },
        `n    `"timesExceeded`": $TimesExceeded,
        `n    `"periodDuration`": $PeriodDuration,
        `n    `"isEnabled`": $NotificationisEnabled
        `n}"
        }
        else {
            $body = "{
        `n    '`$type': `"Event`",
        `n    `"timesExceeded`": $TimesExceeded,
        `n    `"periodDuration`": $PeriodDuration,
        `n    `"isEnabled`": $NotificationisEnabled
        `n}"
        }
    }
    process {
        try {

            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$TestID/notifications/$NotificationID" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -Body $body `
                -OutFile 'Results\APILogs\Add-Notifications.log' `
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

function Remove-Notification{
    [CmdletBinding()]
    param (
        [string]
        $TestID,
        $NotificationID,

        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/tests/$TestID/notifications/$NotificationID" `
                -Headers $AuthHeaders `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-Notification.log' `
                -Method Delete

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
