Import-Module -Name ".\lib\Initialize-APIConfig.psm1" -Force

$v4API = @(Get-ChildItem -Path .\API\v4\*.ps1 -ErrorAction SilentlyContinue)
Foreach ($import in @($v4API)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

if (!(Test-Path Results)) {
    New-Item -ItemType Directory Results -Force
}
if (!(Test-Path 'Results\Logs')) {
    New-Item -ItemType Directory 'Results\APILogs' -Force
}
Export-ModuleMember -Function * -Alias *
