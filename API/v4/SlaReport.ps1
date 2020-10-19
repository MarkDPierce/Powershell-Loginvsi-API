#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
Import-Module -Name ".\API\v4\auth.ps1" -Force -PassThru -WarningAction SilentlyContinue

function Get-SLAReport {
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Get-SLAReport
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

function Remove-SLAReport{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Remove-SLAReport
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

function Add-SLAReport{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Add-SLAReport
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
function Get-SLAReportConfigID{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Get-SLAReportConfigID
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

function Remove-SLAReportConfigID{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Remove-SLAReportConfigID
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

function Edit-SLAReportConfigID{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Edit-SLAReportConfigID
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

function Request-SLAReport{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Request-SLAReport
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

function Add-SLAReportThreshold{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Add-SLAReportThreshold
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

function Edit-SLAReportThreshold{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO:Edit-SLAReportThreshold
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

function Remove-SLAReportThreshold{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO:Remove-SLAReportThreshold
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

function Edit-SLAReportThresholdID{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Edit-SLAReportThresholdID
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

function Remove-SLAReportThresholdID{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Remove-SLAReportThresholdID
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

function Get-SLAReportLogo{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Get-SLAReportLogo
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

function Add-SLAReportLogo{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
            #TODO: Add-SLAReportLogo
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

function Remove-SLAReportLogo{
    [CmdletBinding()]
    param (
        [string]
        $Token = $global:TokenUser
    )
    begin {
        $AuthHeaders = New-AuthHeaders -Token $Token
        $AuthHeaders.Add("accept", "application/json")
    }
    process {
        try {
                #TODO:Remove-SLAReportLogo
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
