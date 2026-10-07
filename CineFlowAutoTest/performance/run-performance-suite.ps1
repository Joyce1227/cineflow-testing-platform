[CmdletBinding()]
param(
    [ValidateSet("smoke", "standard", "stability")]
    [string]$Profile = "smoke",
    [string]$JMeterHome = $env:JMETER_HOME,
    [string]$HostName = "127.0.0.1",
    [int]$Port = 8000,
    [string]$AdminUsername = "admin",
    [string]$AdminPassword = "Admin123"
)

$ErrorActionPreference = "Stop"
$performanceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $performanceDir
$suiteDir = Join-Path $projectDir ("reports\jmeter\suite-{0}-{1}" -f $Profile, (Get-Date -Format "yyyyMMdd-HHmmss"))
$dataDir = Join-Path $suiteDir "data"

$profiles = @{
    smoke = @{
        dataUsers = 5
        readonly = @{ users = 1; ramp = 1; duration = 15 }
        booking = @{ users = 2; ramp = 2; duration = 15 }
        contention = @{ users = 5; ramp = 0; duration = 1 }
    }
    standard = @{
        dataUsers = 50
        readonly = @{ users = 10; ramp = 10; duration = 120 }
        booking = @{ users = 20; ramp = 20; duration = 120 }
        contention = @{ users = 50; ramp = 0; duration = 1 }
    }
    stability = @{
        dataUsers = 50
        readonly = @{ users = 50; ramp = 60; duration = 1800 }
        booking = @{ users = 30; ramp = 60; duration = 1800 }
        contention = @{ users = 50; ramp = 0; duration = 1 }
    }
}
$selected = $profiles[$Profile]
$baseUrl = "http://${HostName}:$Port"

New-Item -ItemType Directory -Path $suiteDir -Force | Out-Null
& python (Join-Path $performanceDir "prepare_performance_data.py") `
    --base-url $baseUrl `
    --output-dir $dataDir `
    --users $selected.dataUsers `
    --admin-username $AdminUsername `
    --admin-password $AdminPassword
if ($LASTEXITCODE -ne 0) { throw "Performance data preparation failed." }

foreach ($scenario in @("readonly", "booking", "contention")) {
    $config = $selected[$scenario]
    $scenarioDir = Join-Path $suiteDir $scenario
    & (Join-Path $performanceDir "run-performance.ps1") `
        -Scenario $scenario `
        -JMeterHome $JMeterHome `
        -HostName $HostName `
        -Port $Port `
        -Users $config.users `
        -RampUp $config.ramp `
        -Duration $config.duration `
        -DataDirectory $dataDir `
        -RunDirectory $scenarioDir
}

Write-Host "All $Profile performance scenarios passed."
Write-Host "Suite reports: $suiteDir"
Write-Host "Keep this metadata for optional cleanup: $(Join-Path $dataDir 'metadata.json')"
