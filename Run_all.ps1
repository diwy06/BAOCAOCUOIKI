param([string]$Julia = 'julia')
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$cli  = Join-Path $root 'bin/dt011.jl'

function Buoc([string]$ten, [string[]]$thamSo) {
    Write-Host ''
    Write-Host ('### ' + $ten) -ForegroundColor Cyan
    & $Julia @thamSo
    if ($LASTEXITCODE -ne 0) { throw ('Buoc that bai: ' + $ten) }
}

Buoc 'Phien ban'      @('--startup-file=no', $cli, 'version')
Buoc 'Bo kiem thu'    @('--startup-file=no', $cli, 'check')
Buoc 'Demo tat ca ca' @('--startup-file=no', $cli, 'demo', '--all')
Buoc 'Lan vet VD01'   @('--startup-file=no', $cli, 'trace', '--case', 'VD01')
Buoc 'Khao sat quy mo' @('--startup-file=no', $cli, 'bench', '--scales', '5,20,100,500', '--seed', '20261020')

Write-Host ''
Write-Host 'END_TO_END_OK: check, demo, trace va bench deu chay xong.' -ForegroundColor Green
