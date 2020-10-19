#Requires -Version 5
$PSDefaultParameterValues['*:Verbose'] = $false
#Import-Module -Name '.\lib\Initialize-APIConfig.psm1' -Force

function Resolve-SelfSignedCerts {
    [CmdletBinding()]
    param ( )

    begin {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
    }

    process {

        if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type) {
            $certallBack =
            @"
    using System;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;
    public class ServerCertificateValidationCallback
    {
        public static void Ignore()
        {
            if(ServicePointManager.ServerCertificateValidationCallback ==null)
            {
                ServicePointManager.ServerCertificateValidationCallback +=
                    delegate
                    (
                        Object obj,
                        X509Certificate certificate,
                        X509Chain chain,
                        SslPolicyErrors errors
                    )
                    {
                        return true;
                    };
            }
        }
    }
"@
            Add-Type $certallBack
        }


        if (-not("dummy" -as [type])) {
            Add-Type -TypeDefinition @"
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public static class Dummy {
    public static bool ReturnTrue(object sender,
        X509Certificate certificate,
        X509Chain chain,
        SslPolicyErrors sslPolicyErrors) { return true; }

    public static RemoteCertificateValidationCallback GetDelegate() {
        return new RemoteCertificateValidationCallback(Dummy.ReturnTrue);
    }
}
"@
        }
    }
    end {
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = [dummy]::GetDelegate()
    }
}
Resolve-SelfSignedCerts

function Get-OAuth2Token {
    [CmdletBinding()]
    param ( )
    try {
        $body = New-Object "System.Collections.Generic.Dictionary[[String], [String]]"
        $body.Add("grant_type", "client_credentials")
        $body.Add("client_id", $Global:APIConfig.Headers.client_id)
        $body.Add("client_secret", $Global:APIConfig.Headers.client_secret)
        $body.Add("scope", $Global:APIConfig.Headers.scope)

        $headers = New-Object "System.Collections.Generic.Dictionary[[String], [String]]"
        $headers.Add("accept", "*/*")

        Resolve-SelfSignedCerts
        $response = Invoke-RestMethod "$Global:BASEURI/identityserver/connect/token" -Method 'POST' -Headers $headers -Body $body

        Write-Output "[AUTHURI] $Global:BASEURI/identityserver/connect/token"
        return $response

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

function Get-AuthHeaderToken {
    try {
        $AuthHeaders = New-Object "System.Collections.Generic.Dictionary[[String], [String]]"
        $token = (Get-OAuth2Token).access_token
        $AuthHeaders.Add("Authorization", "Bearer $token")
        return $AuthHeaders
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

function New-AuthHeaders{
    [CmdletBinding()]
    param (
        [string]
        $Token = (Get-OAuth2Token).access_token
    )
    begin{
        $AuthHeaders = New-Object "System.Collections.Generic.Dictionary[[String], [String]]"
    }
    process{
        $AuthHeaders.Add("Authorization", "Bearer $token")
        $AuthHeaders.Add("Accept", "*/*")
    }
    end{
        return $AuthHeaders
    }
}

<#
    NOTE: @Param:Scope should look like "api.user, api.administrator"
    api.user
    api.observer
    api.operator
    api.administrator
#>
function Grant-TokenWithScope{
    [CmdletBinding()]
    param (
        [System.Array]
        $Scope = @("api.user"),

        [string]
        $Description = $scope[0]
    )
    begin{
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")

        $URI = "{0}/identityserver/api/system-access-token" -f ($Global:APIConfig.URI.BaseURL)

        if ($Scope.Count -gt 1) {
            $r = ($Scope | ConvertTo-Json)
            $body = "{
        `n    `"Scopes`" : $r,
        `n    `"Description`" : `"$Description`"
        `n}"
        }else {
            $r = ($Scope | ConvertTo-Json)
            $body = "{
        `n    `"Scopes`" : [$r],
        `n    `"Description`" : `"$Description`"
        `n}"
        }
    }
    process{
        try {
            $requestData = Invoke-WebRequest -Method POST -Uri $URI -Headers $headers -Body $body
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
        Write-Verbose "[Headers] $headers"
        Write-Verbose "[URI] $URI"
    }
}

function Revoke-TokenId{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TokenId,

        [System.Array]
        $tokens
    )
    begin {
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $URI = "{0}/identityserver/api/system-access-token" -f ($Global:APIConfig.URI.BaseURL)
    }
    process {
        try {
            if ($tokens.count -gt 0 ) {
                foreach($tokenId in $tokens){
                    $body = "[
                            `n    `"$TokenId`"
                            `n]"

                    $response = Invoke-RestMethod $URI -Method 'DELETE' -Headers $headers -Body $body
                }
            }
            else {
                $body = "[
                        `n    `"$TokenId`"
                        `n]"
                $response = Invoke-RestMethod $URI -Method 'DELETE' -Headers $headers -Body $body
            }
            return $response
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
    end {
        Write-Verbose "[URI] $URI"
    }
}

function Get-Tokens{
    <#
        Issues with the request via code, need to figure it out
    #>
    begin{
        Resolve-SelfSignedCerts
    }
    process{
        try {
            $URI = "{0}/identityserver/api/system-access-token" -f ($Global:APIConfig.URI.BaseURL)

            $requestData = Invoke-WebRequest `
                -Uri $URI `
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
        Write-Verbose "[URI] https://p34-appliance.play.loginvsi.com/identityserver/api/system-access-token"
    }
}

function Grant-AllScopeTokens{
    begin{
        #New-Variable -Name FullScopeCreated -Scope Global -Value $false -Option ReadOnly
    }
    process{
        try {
            New-Variable -Name TokenUser -Scope Global -Value (Grant-TokenWithScope -Scope "api.user").Content -Force -Option ReadOnly
            New-Variable -Name TokenObserver -Scope Global -Value (Grant-TokenWithScope -Scope "api.observer").Content -Force -Option ReadOnly
            New-Variable -Name TokenOperator -Scope Global -Value (Grant-TokenWithScope -Scope "api.operator").Content -Force -Option ReadOnly
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
        #New-Variable -Name FullScopeCreated -Value $true -Force -Scope Global
        #Return $Global:FullScopeCreated
    }
}

function Out-AllScopeTokens{

    $dumpObj = @{
        "User"          = $Global:TokenUser
        "Observer"      = $Global:TokenObserver
        "Operator"      = $Global:TokenOperator
    }

    $jsonDump = ConvertTo-Json -InputObject $dumpObj

    Out-File -InputObject $jsonDump .\tokens.json -Force

}

function Set-TokensFromJson{
    begin {

    }
    process{
        try {
            $tokenJson = Get-Content ./tokens.json -Raw
            $tokens = ConvertFrom-Json -InputObject $tokenJson

            New-Variable -Name TokenUser -Scope Global -Value $tokens.User -Force -Option ReadOnly

            New-Variable -Name TokenObserver -Scope Global -Value $tokens.Observer -Force -Option ReadOnly

            New-Variable -Name TokenOperator -Scope Global -Value $tokens.Operator -Force -Option ReadOnly

        }
        catch {
            Write-Error $_
        }
    }
    end {

    }
}

function Remove-AllTokenIds{
    ((get-tokens).content | ConvertFrom-Json).id

    foreach ($tid in ((get-tokens).content | ConvertFrom-Json).id) {
        Revoke-TokenID -TokenId $tid
    }
    return (Get-Tokens).content
}
