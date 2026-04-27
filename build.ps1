param(
    [string]$Clang = "clang",
    [string]$Target = "",
    [switch]$Clean
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcDir = Join-Path $root "src"
$outDir = Join-Path $root ".build"
$objDir = Join-Path $outDir "obj"
$isWindowsTarget = $IsWindows -or ($Target -match "windows")
$exeName = if ($isWindowsTarget) { "snc.exe" } else { "snc" }
$exePath = Join-Path $root $exeName

if ($Clean) {
    if (Test-Path $outDir) {
        Remove-Item -LiteralPath $outDir -Recurse -Force
    }
    if (Test-Path $exePath) {
        Remove-Item -LiteralPath $exePath -Force
    }
    return
}

New-Item -ItemType Directory -Force -Path $objDir | Out-Null

$commonArgs = @("-x", "assembler-with-cpp")
if ($Target) {
    $commonArgs += @("--target", $Target)
}

$objFiles = @()
Get-ChildItem $srcDir -Filter *.s | Sort-Object Name | ForEach-Object {
    $objExt = if ($IsWindows) { ".obj" } else { ".o" }
    $objPath = Join-Path $objDir ($_.BaseName + $objExt)
    & $Clang @commonArgs -c $_.FullName -o $objPath
    if ($LASTEXITCODE -ne 0) {
        throw "Failed compiling $($_.Name)"
    }
    $objFiles += $objPath
}

& $Clang @commonArgs @objFiles -o $exePath
if ($LASTEXITCODE -ne 0) {
    throw "Failed linking $exeName"
}

Write-Host "Built $exePath"
