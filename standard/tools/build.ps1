param(
    [Parameter(Mandatory = $true)] [string] $SmaliJar,
    [Parameter(Mandatory = $true)] [string] $SmaliDeps,
    [Parameter(Mandatory = $true)] [string] $AndroidJar,
    [Parameter(Mandatory = $true)] [string] $BuildTools,
    [string] $Keystore = "$env:USERPROFILE\.android\debug.keystore",
    [string] $KeystorePass = "android",
    [string] $KeyAlias = "androiddebugkey",
    [string] $KeyPass = "android",
    [string] $Java = "java",
    [string] $Python = "python"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$build = Join-Path $root "build"
$dist = Join-Path $root "dist"
New-Item -ItemType Directory -Force -Path $build, $dist | Out-Null

$classesDex = Join-Path $build "classes.dex"
$baseApk = Join-Path $build "base.apk"
$unsignedApk = Join-Path $build "unsigned.apk"
$alignedApk = Join-Path $build "aligned.apk"
$outApk = Join-Path $dist "bieshui.apk"

Write-Host "[1/6] assemble smali"
& $Java -cp "$SmaliJar;$SmaliDeps" org.jf.smali.Main assemble -o $classesDex (Join-Path $root "smali")
if ($LASTEXITCODE -ne 0) { throw "smali assemble failed" }

Write-Host "[2/6] aapt package"
& (Join-Path $BuildTools "aapt.exe") package -f `
    -M (Join-Path $root "AndroidManifest.xml") `
    -S (Join-Path $root "res") `
    -I $AndroidJar `
    -F $baseApk
if ($LASTEXITCODE -ne 0) { throw "aapt package failed" }

Write-Host "[3/6] merge classes.dex"
& $Python (Join-Path $PSScriptRoot "pack.py") $baseApk $classesDex $unsignedApk
if ($LASTEXITCODE -ne 0) { throw "pack.py failed" }

Write-Host "[4/6] zipalign"
& (Join-Path $BuildTools "zipalign.exe") -f -p 4 $unsignedApk $alignedApk
if ($LASTEXITCODE -ne 0) { throw "zipalign failed" }

Write-Host "[5/6] sign"
& $Java -jar (Join-Path $BuildTools "lib\apksigner.jar") sign `
    --ks $Keystore `
    --ks-pass "pass:$KeystorePass" `
    --key-pass "pass:$KeyPass" `
    --ks-key-alias $KeyAlias `
    --out $outApk `
    $alignedApk
if ($LASTEXITCODE -ne 0) { throw "apksigner failed" }

Write-Host "[6/6] verify"
& $Java -jar (Join-Path $BuildTools "lib\apksigner.jar") verify --verbose $outApk
if ($LASTEXITCODE -ne 0) { throw "apksigner verify failed" }

Write-Host "OK: $outApk"
