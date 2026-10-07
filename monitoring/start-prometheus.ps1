param(
    [string]$PrometheusHome = "D:\MonitoringTools\prometheus-3.15.0.windows-amd64"
)

$ErrorActionPreference = "Stop"
$prometheus = Join-Path $PrometheusHome "prometheus.exe"
$promtool = Join-Path $PrometheusHome "promtool.exe"
$config = Join-Path $PSScriptRoot "prometheus.windows.yml"
$storage = Join-Path $PSScriptRoot "data"

if (-not (Test-Path -LiteralPath $prometheus)) {
    throw "Prometheus not found: $prometheus"
}

& $promtool check config $config
if ($LASTEXITCODE -ne 0) {
    throw "Prometheus configuration validation failed."
}

New-Item -ItemType Directory -Force -Path $storage | Out-Null
Write-Host "Prometheus: http://localhost:9090"
Write-Host "CineFlow target: http://localhost:9090/targets"
& $prometheus --config.file=$config --storage.tsdb.path=$storage
