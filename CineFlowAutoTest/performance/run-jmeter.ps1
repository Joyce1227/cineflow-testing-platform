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

$performanceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
& (Join-Path $performanceDir "run-performance.ps1") `
    -Scenario readonly `
    -JMeterHome $JMeterHome `
    -Protocol $Protocol `
    -HostName $HostName `
    -Port $Port `
    -Username $Username `
    -Password $Password `
    -Users $Users `
    -RampUp $RampUp `
    -Duration $Duration `
    -ThinkTime $ThinkTime `
    -MaxResponseMs $MaxResponseMs
