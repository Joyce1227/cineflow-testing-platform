[CmdletBinding()]
param(
    [ValidateSet("readonly", "booking", "contention")]
    [string]$Scenario = "readonly",
    [string]$JMeterHome = $env:JMETER_HOME,
    [ValidateSet("http", "https")]
    [string]$Protocol = "http",
    [string]$HostName = "127.0.0.1",
    [ValidateRange(1, 65535)]
    [int]$Port = 8000,
    [string]$Username = "test_user",
    [string]$Password = "Test1234",
    [string]$AdminUsername = "admin",
    [string]$AdminPassword = "Admin123",
    [ValidateRange(1, 1300)]
    [int]$Users = 10,
    [ValidateRange(0, 86400)]
    [int]$RampUp = 10,
    [ValidateRange(1, 86400)]
    [int]$Duration = 60,
    [ValidateRange(0, 60000)]
    [int]$ThinkTime = 500,
    [ValidateRange(1, 120000)]
    [int]$MaxResponseMs = 2000,
    [ValidateRange(0, 100)]
    [double]$MaxErrorRate = 0,
    [string]$DataDirectory,
    [string]$RunDirectory
)

$ErrorActionPreference = "Stop"

$performanceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $performanceDir

if ([string]::IsNullOrWhiteSpace($JMeterHome)) {
    $knownHome = "D:\apache-jmeter-5.6.3\apache-jmeter-5.6.3"
    if (Test-Path -LiteralPath $knownHome -PathType Container) {
        $JMeterHome = $knownHome
    }
}
if ([string]::IsNullOrWhiteSpace($JMeterHome)) {
    throw "JMETER_HOME is not set. Pass -JMeterHome with the Apache JMeter installation directory."
}

$jmeter = Join-Path $JMeterHome "bin\jmeter.bat"
if (-not (Test-Path -LiteralPath $jmeter -PathType Leaf)) {
    throw "JMeter executable was not found at: $jmeter"
}

if ([string]::IsNullOrWhiteSpace($RunDirectory)) {
    $runId = Get-Date -Format "yyyyMMdd-HHmmss"
    $RunDirectory = Join-Path $projectDir "reports\jmeter\$Scenario-$runId"
}
$RunDirectory = [System.IO.Path]::GetFullPath($RunDirectory)
New-Item -ItemType Directory -Path $RunDirectory -Force | Out-Null

$plans = @{
    readonly = "cineflow-api-performance.jmx"
    booking = "cineflow-booking-performance.jmx"
    contention = "cineflow-seat-contention.jmx"
}
$testPlan = Join-Path $performanceDir $plans[$Scenario]
$baseUrl = "${Protocol}://${HostName}:$Port"

$dataFile = $null
$metadataFile = $null
if ($Scenario -ne "readonly") {
    if ([string]::IsNullOrWhiteSpace($DataDirectory)) {
        $DataDirectory = Join-Path $RunDirectory "data"
        & python (Join-Path $performanceDir "prepare_performance_data.py") `
            --base-url $baseUrl `
            --output-dir $DataDirectory `
            --users $Users `
            --admin-username $AdminUsername `
            --admin-password $AdminPassword
        if ($LASTEXITCODE -ne 0) {
            throw "Performance data preparation failed with exit code $LASTEXITCODE."
        }
    }
    $csvName = if ($Scenario -eq "booking") { "booking-users.csv" } else { "contention-users.csv" }
    $dataFile = Join-Path $DataDirectory $csvName
    $metadataFile = Join-Path $DataDirectory "metadata.json"
    if (-not (Test-Path -LiteralPath $dataFile -PathType Leaf)) {
        throw "Performance data file was not found: $dataFile"
    }
    $availableRows = @(Import-Csv -LiteralPath $dataFile).Count
    if ($availableRows -lt $Users) {
        throw "The data file has $availableRows users, but the test requests $Users. Prepare more data first."
    }
    $dataFile = $dataFile.Replace("\", "/")
}

$jtlFile = Join-Path $RunDirectory "results.jtl"
$reportDir = Join-Path $RunDirectory "html"
$jmeterLog = Join-Path $RunDirectory "jmeter.log"

$arguments = @(
    "-n", "-t", $testPlan,
    "-l", $jtlFile,
    "-j", $jmeterLog,
    "-e", "-o", $reportDir,
    "-Jprotocol=$Protocol",
    "-Jhost=$HostName",
    "-Jport=$Port",
    "-Jusername=$Username",
    "-Jpassword=$Password",
    "-Jusers=$Users",
    "-Jramp_up=$RampUp",
    "-Jduration=$Duration",
    "-Jthink_time=$ThinkTime",
    "-Jmax_response_ms=$MaxResponseMs",
    "-Jjmeter.save.saveservice.output_format=csv",
    "-Jjmeter.save.saveservice.print_field_names=true",
    "-Jjmeter.save.saveservice.timestamp_format=ms"
)
if ($dataFile) {
    $arguments += "-Jdata_file=$dataFile"
}

Write-Host "Scenario=$Scenario users=$Users ramp-up=${RampUp}s duration=${Duration}s target=$baseUrl"
& $jmeter @arguments
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $jtlFile -PathType Leaf)) {
    throw "JMeter process failed with exit code $LASTEXITCODE. Log: $jmeterLog"
}

& python (Join-Path $performanceDir "summarize_jtl.py") `
    --jtl $jtlFile `
    --output-dir $RunDirectory `
    --max-error-rate $MaxErrorRate
if ($LASTEXITCODE -ne 0) {
    throw "Performance quality gate failed. See: $(Join-Path $RunDirectory 'summary.md')"
}

Write-Host "Performance test passed."
Write-Host "Summary: $(Join-Path $RunDirectory 'summary.md')"
Write-Host "HTML report: $(Join-Path $reportDir 'index.html')"
if ($metadataFile) {
    Write-Host "Cleanup metadata: $metadataFile"
}
