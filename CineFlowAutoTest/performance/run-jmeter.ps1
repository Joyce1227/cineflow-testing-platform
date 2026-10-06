[CmdletBinding()]
param(
    [string]$JMeterHome = $env:JMETER_HOME,
    [string]$Protocol = "http",
    [string]$HostName = "127.0.0.1",
    [int]$Port = 8000,
    [string]$Username = "test_user",
    [string]$Password = "Test1234",
    [int]$Users = 10,
    [int]$RampUp = 10,
    [int]$Duration = 60,
    [int]$ThinkTime = 500,
    [int]$MaxResponseMs = 2000
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($JMeterHome)) {
    throw "JMETER_HOME is not set. Pass -JMeterHome with the Apache JMeter installation directory."
}

$jmeter = Join-Path $JMeterHome "bin\jmeter.bat"
if (-not (Test-Path -LiteralPath $jmeter -PathType Leaf)) {
    throw "JMeter executable was not found at: $jmeter"
}

$performanceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $performanceDir
$testPlan = Join-Path $performanceDir "cineflow-api-performance.jmx"
$runId = Get-Date -Format "yyyyMMdd-HHmmss"
$runDir = Join-Path $projectDir "reports\jmeter\$runId"
$jtlFile = Join-Path $runDir "results.jtl"
$reportDir = Join-Path $runDir "html"

New-Item -ItemType Directory -Path $runDir -Force | Out-Null

Write-Host "Starting JMeter: users=$Users, ramp-up=${RampUp}s, duration=${Duration}s."

& $jmeter `
    -n `
    -t $testPlan `
    -l $jtlFile `
    -e `
    -o $reportDir `
    "-Jprotocol=$Protocol" `
    "-Jhost=$HostName" `
    "-Jport=$Port" `
    "-Jusername=$Username" `
    "-Jpassword=$Password" `
    "-Jusers=$Users" `
    "-Jramp_up=$RampUp" `
    "-Jduration=$Duration" `
    "-Jthink_time=$ThinkTime" `
    "-Jmax_response_ms=$MaxResponseMs"

if ($LASTEXITCODE -ne 0) {
    throw "JMeter failed with exit code $LASTEXITCODE. Results: $jtlFile"
}

Write-Host "JMeter test completed."
Write-Host "Raw results: $jtlFile"
Write-Host "HTML report: $(Join-Path $reportDir 'index.html')"
