function Import-Config {
    <#
        Imports our config
        TODO: Clean-up this helper function, Synopsis, Descriptions, Examples
    #>
    begin {
    }
    process {
        try {
            New-Variable -Scope Global -Name ApiConfig -Value (ConvertFrom-Json -InputObject (Get-Content -Raw ".\apiconfig.json")) -Force
            New-Variable -Scope Global -Name BASEURI -Value $Global:APIConfig.URI.BaseURL -Force
            New-Variable -Scope Global -Name apiVersion -Value $Global:APIConfig.URI.ApiVer -Force
        }
        catch {
            Write-Error $_
        }
    }
}
Import-Config
