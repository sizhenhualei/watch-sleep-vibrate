param(
    [string] $Jdk = "E:\sanxing\tools\jdk17\jdk-17.0.13+11",
    [string] $AndroidJar = "E:\sanxing\tools\platform-35\android-35\android.jar",
    [string] $BuildTools = "E:\sanxing\tools\android-15",
    [string] $Keystore = "E:\sanxing\tools\debug.keystore",
    [string] $KeystorePass = "android",
    [string] $KeyAlias = "androiddebugkey",
    [string] $KeyPass = "android",
    [string] $Python = "C:\Users\hualei\tools\python313\python.exe",
    [string] $Manifest = "",
    [string] $OutApk = ""
)

$ErrorActionPreference = "Continue"
$root = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($Manifest)) {
    $Manifest = Join-Path $root "AndroidManifest.xml"
} elseif (-not [System.IO.Path]::IsPathRooted($Manifest)) {
    $Manifest = Join-Path $root $Manifest
}
if ([string]::IsNullOrWhiteSpace($OutApk)) { $OutApk = "ndz-unified.apk" }
$build = Join-Path $root "build"
$dist = Join-Path $root "dist"
$classes = Join-Path $build "classes"
$dexDir = Join-Path $build "dex"
New-Item -ItemType Directory -Force -Path $build, $dist, $classes, $dexDir | Out-Null
$manifestForAapt = Join-Path $build "AndroidManifest.xml"
Copy-Item $Manifest $manifestForAapt -Force
Get-ChildItem $classes -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem $dexDir -File -ErrorAction SilentlyContinue | Remove-Item -Force

$javac = Join-Path $Jdk "bin\javac.exe"
$java = Join-Path $Jdk "bin\java.exe"
$src = @(
    (Join-Path $root "src\com\example\vibrate5s\MainActivity.java"),
    (Join-Path $root "src\com\example\vibrate5s\MonitorService.java")
)

Write-Host "[1/7] javac"
& $javac --release 8 -encoding UTF-8 -cp $AndroidJar -d $classes $src
if ($LASTEXITCODE -ne 0) { throw "javac failed" }

Write-Host "[2/7] d8"
$classFiles = Get-ChildItem $classes -Recurse -Filter *.class | ForEach-Object FullName
& $java -cp (Join-Path $BuildTools "lib\d8.jar") com.android.tools.r8.D8 `
    --release --min-api 28 --lib $AndroidJar --output $dexDir $classFiles
if ($LASTEXITCODE -ne 0) { throw "d8 failed" }

Write-Host "[3/7] aapt package"
$baseApk = Join-Path $build "base.apk"
& (Join-Path $BuildTools "aapt.exe") package -f `
    -M $manifestForAapt `
    -S (Join-Path $root "res") `
    -I $AndroidJar `
    -F $baseApk
if ($LASTEXITCODE -ne 0) { throw "aapt package failed" }

Write-Host "[4/7] merge classes.dex"
$unsignedApk = Join-Path $build "unsigned.apk"
& $Python (Join-Path $PSScriptRoot "pack.py") $baseApk (Join-Path $dexDir "classes.dex") $unsignedApk
if ($LASTEXITCODE -ne 0) { throw "pack.py failed" }

Write-Host "[5/7] zipalign"
$alignedApk = Join-Path $build "aligned.apk"
& (Join-Path $BuildTools "zipalign.exe") -f -p 4 $unsignedApk $alignedApk
if ($LASTEXITCODE -ne 0) { throw "zipalign failed" }

Write-Host "[6/7] sign"
$outApk = Join-Path $dist $OutApk
& $java -jar (Join-Path $BuildTools "lib\apksigner.jar") sign `
    --ks $Keystore --ks-pass "pass:$KeystorePass" `
    --key-pass "pass:$KeyPass" --ks-key-alias $KeyAlias `
    --out $outApk $alignedApk
if ($LASTEXITCODE -ne 0) { throw "apksigner failed" }

Write-Host "[7/7] verify"
& $java -jar (Join-Path $BuildTools "lib\apksigner.jar") verify --verbose $outApk
if ($LASTEXITCODE -ne 0) { throw "apksigner verify failed" }

Write-Host "OK: $outApk"
