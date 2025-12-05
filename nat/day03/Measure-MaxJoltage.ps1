<#
.SYNOPSIS
    Solution to day 03 of the Advent of Code 2025 implemented in pwsh.

.DESCRIPTION
    Parses information about a series of battery banks from the specified input
    file or pipeline data and calculates the maximum achievable joltage under
    different constraints.

.PARAMETER InputPath
    Path to the input file to process. This can either be the test input or the
    full day 03 input file.

.EXAMPLE
    .\Measure-MaxJoltage.ps1 -InputPath .\input

    Use the script to parse the battery bank information from the "input" file,
    and output the maximum achievable joltages.

.EXAMPLE
    Get-Content input | .\Measure-MaxJoltage.ps1

    Use the script to parse the battery bank information from the contents of
    the "input" file, and output the maximum achievable joltages.

.NOTES
    Author: Nathaniel Struselis
    GitHub: https://github.com/NathanielJS1541
    Source: https://github.com/NathanielJS1541/AoC_2025/blob/main/nat/day03/Measure-MaxJoltage.ps1
    SPDX-License-Identifier: AGPL-3.0-only
#>

# Define the parameters and parameter schemes that the script accepts.
#
# Default to the "Path" parameter set, which requires an input file path. The
# "Pipeline" parameter set allows input data to be provided via the pipeline.
[CmdletBinding(DefaultParameterSetName = 'Path')]
param (
    # When using the "Path" parameter set, the path to the input file is
    # required. This is the default parameter set.
    [Parameter(ParameterSetName = 'Path', Mandatory = $true)]
    [string]$InputPath,

    # When using the "Pipeline" parameter set, lines of input can be provided
    # via the pipeline.
    [Parameter(ParameterSetName = 'Pipeline', ValueFromPipeline = $true)]
    [string]$InputObject
)

begin {
    # If using the "Path" parameter set, validate that the input file exists.
    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        # Resolve the specified path and update the input variable.
        $InputPath = (Resolve-Path -Path $InputPath).ProviderPath

        # Check if the path is valid and points to a file.
        #
        # The "Leaf" PathType specifies that the path must point to a file (leaf
        # of the directory tree) rather than a directory (a container).
        if (-not (Test-Path -Path $InputPath -PathType Leaf)) {
            # Throw a terminating error if the input file does not exist.
            throw [System.IO.FileNotFoundException]::new(
                "Input file '$InputPath' does not exist."
            )
        }
    }

    # Initialise variables to store the sum of the maximum joltage in the
    # battery banks for configurations with two active batteries, and twelve
    # active batteries.
    $script:maxJoltageTwoBatteries = 0
    $script:maxJoltageTwelveBatteries = 0
}
process {
    function Measure-MaxBankJoltage {
        <#
        .SYNOPSIS
            Measure the maximum joltage achievable in a particular battery bank,
            when turning on the specified number of batteries.

        .PARAMETER activeBatteries
            [int]
            The number of batteries that can be turned on in the bank.

        .PARAMETER bankJoltages
            [string]
            A string representing the joltages of each battery in the entire
            bank.

        .OUTPUTS
            [int]
            The maximum achievable joltage in the battery bank when turning on
            the specified number of batteries.
        #>

        # Define the parameters that the function accepts.
        param (
            # The number of batteries to turn on in the bank.
            [Parameter(Mandatory = $true)]
            [int]$activeBatteries,
            # The joltages of each battery in the entire bank, as a string.
            [Parameter(Mandatory = $true)]
            [string]$bankJoltages
        )

        # Split the bank joltages string into an array of integers, ignoring any
        # non-digit strings that may be introduced by the split operation as
        # these could pollute the data.
        $joltageArray = (
            $bankJoltages -split '' |
            Where-Object { $_ -match '^\d$' } |
            ForEach-Object { [int]$_ }
        )

        # Clamp the number of active batteries to the available bank size to
        # avoid range errors.
        $activeBatteries = [Math]::Min($activeBatteries, $joltageArray.Length)

        # Initialise a variable to store the maximum bank joltage. This is
        # stored as a string to make appending digits easier. It will be cast to
        # an int before returning.
        $maximumBankJoltage = ''

        # Initialise a variable to track the index of the last active battery.
        $lastActiveBattery = -1

        # Loop through the number of active batteries to be turned on,
        # identifying the optimum battery to turn on for each.
        foreach ($battery in 1..$activeBatteries) {
            # The first battery that can be turned on is the battery after the
            # last active battery.
            $firstBattery = $lastActiveBattery + 1

            # The last battery that can be turned on is determined by the number
            # of batteries left to activate, and the number of batteries that
            # are available.
            #
            # The batteries cannot be re-ordered, so the selection must leave at
            # least enough batteries remaining to turn on the required number of
            # batteries.
            $lastBattery = (
                $joltageArray.Length - ($activeBatteries - $battery) - 1
            )

            # Initialise variables to track the maximum battery joltage in the
            # range and its index.
            $maxBatteryJoltage = -1
            $maxBatteryIndex = -1

            # Identify the battery with the maximum joltage in the available
            # range, preferring the earliest index on ties to leave more
            # batteries available for later ranges.
            foreach ($batteryIndex in $firstBattery..$lastBattery) {
                # Get the joltage of the current battery.
                $joltage = $joltageArray[$batteryIndex]

                # Test if this battery has a higher joltage than the current
                # maximum.
                if ($joltage -gt $maxBatteryJoltage) {
                    # This battery has a new maximum joltage. Update the
                    # tracking variables.
                    $maxBatteryJoltage = $joltage
                    $maxBatteryIndex = $batteryIndex
                }

                # The battery joltages are constrained to a single digit. If the
                # current maximum is now 9, we cannot do better, so break early.
                if ($maxBatteryJoltage -eq 9) {
                    break
                }
            }

            # If the maximum battery index is still -1, no valid battery was
            # found. Throw a terminating exception.
            if ($maxBatteryIndex -lt 0) {
                throw [System.Exception]::new(
                    "Could not find valid battery in the bank array."
                )
            }

            # Update the last active battery index to the absolute index.
            $lastActiveBattery = $maxBatteryIndex

            # Append the maximum battery joltage to the total maximum bank
            # joltage string.
            $maximumBankJoltage += $maxBatteryJoltage
        }

        # Return the maximum battery joltage string, casting it as an int after
        # all digits have been appended.
        [long]$maximumBankJoltage
    }

    function Add-BankJoltage {
        <#
        .SYNOPSIS
            Add the maximum joltage achievable in a particular battery bank to
            the script-level accumulations for both configurations.

        .PARAMETER bankJoltages
            [string]
            A string representing the joltages of each battery in the entire
            bank.
        #>

        # Define the parameters that the function accepts.
        param (
            # The joltages of each battery in the entire bank, as a string.
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [string]$bankJoltages
        )

        # Create a hashtable to store the parameters for the
        # Measure-MaxBankJoltage function.
        $bankParams = @{
            bankJoltages = $bankJoltages
        }

        # Accumulate the maximum joltage for the bank when only 2 batteries are
        # active.
        $bankParams.activeBatteries = 2
        $script:maxJoltageTwoBatteries += Measure-MaxBankJoltage @bankParams

        # Accumulate the maximum joltage for the bank when 12 batteries are
        # active.
        $bankParams.activeBatteries = 12
        $script:maxJoltageTwelveBatteries += Measure-MaxBankJoltage @bankParams
    }

    # Process input based on the active parameter set.
    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        # For the "Path" parameter set, stream the input file line-by-line and
        # process incrementally.
        #
        # ReadCount 1 ensures that each line is processed individually.
        Get-Content -Path $InputPath -ReadCount 1 | ForEach-Object {
            # Process each line as a separate bank of joltages.
            Add-BankJoltage -bankJoltages $_
        }
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'Pipeline') {
        # For the "Pipeline" parameter set, data is streamed in directly from
        # the pipeline. Process it as it arrives.
        Add-BankJoltage -bankJoltages $InputObject
    }
}
end {
    Write-Output "Advent of Code 2025 Day 03:"

    # Create and output a structured object with the results for both battery
    # configurations.
    $result = [pscustomobject]@{
        'Max. Joltage 2 Batteries'  = [long]$script:maxJoltageTwoBatteries
        'Max. Joltage 12 Batteries' = [long]$script:maxJoltageTwelveBatteries
    }

    # Output the result object in a formatted list for readability.
    $result | Format-List
}
