@{
    ModuleVersion = '1.0.0'
    RootModule = 'LoginVSI-API.psm1'
    GUID          = 'cf26d418-597d-4e1f-9c78-703371f36032'
    CompanyName = 'Paddlers'
    Author = 'Mark Pierce'
    Copyright     = '(c) 2020 Mark D Pierce. All rights reserved.'
    # Description of the functionality provided by this module
    Description       = 'API Module for Login VSI enterprise'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    FileList          = @('config.json')

    # Cmdlets to export from this module
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport   = '*'
    FunctionsToExport = @('*')

    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = @('API')

            # A URL to the license for this module.
            LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri = ''

        } # End of PSData hashtable

    }
}
