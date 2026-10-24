$ErrorActionPreference = 'Stop'
$botRoot = $PSScriptRoot
$botUrl = 'http://127.0.0.1:8001/'
function Test-MaiBotReady {
    try {
        $response = Invoke-WebRequest -Uri $botUrl -UseBasicParsing -TimeoutSec 2
        return $response.StatusCode -eq 200
    } catch { return $false }
}
if (Test-MaiBotReady) {
    Start-Process $botUrl
    exit
}
$botExe = Join-Path $botRoot '.venv\Scripts\maibot.exe'
$instancePath = Join-Path $botRoot 'instance'
if (-not (Test-Path -LiteralPath $botExe)) { throw 'MaiBot executable is missing.' }
# Keep the service console visible so it can be stopped with Ctrl+C.
$botProcess = Start-Process -FilePath $botExe -ArgumentList 'run' -WorkingDirectory $instancePath -PassThru
Write-Host 'Starting MaiBot. The browser will open when it is ready...'
for ($attempt = 0; $attempt -lt 60; $attempt++) {
    if (Test-MaiBotReady) {
        Start-Process $botUrl
        exit
    }
    Start-Sleep -Seconds 2
}
Write-Host 'MaiBot did not become ready. Check the service console for details.'
Read-Host 'Press Enter to close'
