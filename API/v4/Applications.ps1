#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue
function Get-Applications{
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $false)]
        [ValidateSet('name', 'description')]
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

        [ValidateSet('all', 'none', 'script', 'timers')]
        [string]
        $includeOptions,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params += "orderBy=$OrderBy&direction=$Direction&count=$Count"

        if ($includeTotalCount) {
            $params += "&includeTotalCount=$includeTotalCount"
        }
        if ($includeOptions) {
            $params += "&includeOptions=$includeOptions"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/applications?$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-Applications.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/applications?$params"
    }
}

function Get-ApplicationsID{
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $ApplicationID,

        [ValidateSet('none', 'script', 'timers', 'all')]
        [string]
        $includeOptions,

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        $params = "/$ApplicationID"

        If ($includeOptions) {
            $params += "?includeOptions=$includeOptions"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/applications$params" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Get-ApplicationsID.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/applications$params"
    }
}

function Add-Application{
    [CmdletBinding()]
    param (
        [ValidateSet('WindowsApp', 'WebApp')]
        [string]
        $AppType,

        [string]
        $ApplicationName='blank name',
        $AppDescription='blank desc',
        $AppUserName='foobar',
        $AppPass='barfoo',
        $WorkingDirectory = 'c:\windows\system32\',
        $CommandLine= 'notepad.exe',
        $StartURl = 'https:\\foobar.com',
        $BrowserName = 'Chrome',

        [string]
        $Token = $global:TokenUser
    )
    begin{
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($AppType -eq 'WindowsApp'){
            $body = @{
                '$type'       = "WindowsApp";
                'CommandLine'      = $CommandLine;
                'WorkingDirectory' = $WorkingDirectory;
                'name'        = $ApplicationName;
                "description" = $AppDescription;
                "userName"    = $AppUserName;
                "password"    = $AppPass
            }
        }else {
            $body = @{
                '$type'      ="WebApp";
                "BrowserName" = $BrowserName;
                "name"        = $ApplicationName;
                "description" = $AppDescription;
                "userName"    = $AppUserName;
                "password"    = $AppPass;
                "StartUrl"    = $StartURl
            }
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/applications" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Add-Application.log' `
                -Body ($body | ConvertTo-Json) `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/applications"
    }
}

function Edit-Application{
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string]
        $ApplicationID,

        [ValidateSet('WindowsApp', 'WebApp')]
        [string]
        $AppType,

        [string]
        $NewAppName = '',
        $NewAppDescription = '',
        $NewAppUserName = '',
        $NewAppPass = '',
        $NewCommandLine = '',
        $NewWorkingDirectory='',
        $NewStartURl = '',
        $NewBrowserName = '',
        $BrowserName = '',

        [string]
        $Token = $global:TokenUser
    )

    begin{
        if($NewAppPass.count -gt 0){
            $pvalue = "true"
        }else{
            $pvalue = "false"
        }

        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($AppType -eq 'WindowsApp') {
            $body = @{
                '$type'       = "WindowsApp";
                "name"               = "$NewAppName";
                "description"        = "$NewAppDescription";
                "userName"           = "$NewAppUserName";
                "password"           = "$NewAppPass";
                "CommandLIne"        = "$NewCommandLine";
                "WorkingDirectory"   = "$NewWorkingDirectory";
                "mustUpdatePassword" = "$pvalue"
            }
        }else{
            $body = @{
                '$type'       = "WebApp";
                "BrowserName"        = "$BrowserName";
                "name"        = "$NewBrowserName";
                "description" = "$NewAppDescription";
                "userName"    = "$NewAppUserName";
                "password"    = "$NewAppPass";
                "mustUpdatePassword" = "$pvalue";
                "StartUrl"    = "$NewStartURl"
            }
        }
    }
    process{
        try {

            $requestData = Invoke-WebRequest -Uri "$Global:BASEURI/$apiVersion/applications/$ApplicationID" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Edit-Application.log' `
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
    end{
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/applications/$ApplicationID"
    }
}

function Remove-Applications {
    [CmdletBinding()]
    param (
        [System.Array]
        $AppIDs,

        [string]
        $Token = $global:TokenUser
    )

    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")

        if ($AppIDs.Count -gt 1) {
            $r = ($AppIDs | ConvertTo-Json)
            $body = "`n
                    `n $r
            `n "
        }else {
            $r = ($AppIDs | ConvertTo-Json)
            $body = "[`n
                    `n $r
            `n]"
        }
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/applications" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-Applications.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/applications"
    }
}

function Remove-ApplicationID {
    [CmdletBinding()]
    param (
        [System.Array]
        $AppID,

        [string]
        $Token = $global:TokenUser
    )

    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            $requestData = Invoke-RestMethod -Uri "$Global:BASEURI/$apiVersion/applications/$AppID" `
                -Headers $AuthHeaders `
                -UseBasicParsing `
                -Body $body `
                -ContentType 'application/json' `
                -TimeoutSec 10 `
                -DisableKeepAlive `
                -PassThru `
                -OutFile 'Results\APILogs\Remove-ApplicationID.log' `
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
        Write-Verbose "[URI] $Global:BASEURI/$apiVersion/applications/$AppID"
    }
}
