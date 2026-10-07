[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Metadata,
    [Parameter(Mandatory = $true)]
    [string]$DatabaseUrl,
    [switch]$AllowRemote
)

$ErrorActionPreference = "Stop"
$performanceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$arguments = @(
    (Join-Path $performanceDir "cleanup_performance_data.py"),
    "--metadata", $Metadata,
    "--database-url", $DatabaseUrl
)
if ($AllowRemote) { $arguments += "--allow-remote" }

& python @arguments
if ($LASTEXITCODE -ne 0) {
    throw "Performance data cleanup failed with exit code $LASTEXITCODE."
}
