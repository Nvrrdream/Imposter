
param()

$ErrorActionPreference = 'Stop'

Set-Location $PSScriptRoot

$pubspecPath = Join-Path $PSScriptRoot 'pubspec.yaml'
$apkPath = Join-Path $PSScriptRoot 'build\app\outputs\flutter-apk\app-release.apk'

if (-not (Test-Path $pubspecPath)) {
    throw 'pubspec.yaml was not found.'
}

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw 'Flutter was not found in PATH.'
}

$content = [System.IO.File]::ReadAllText($pubspecPath)

$pattern = '(?m)^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$'
$match = [regex]::Match($content, $pattern)

if (-not $match.Success) {
    throw 'Could not read version. Expected format: version: 0.1.0+3'
}

$major = [int]$match.Groups[1].Value
$minor = [int]$match.Groups[2].Value
$patch = [int]$match.Groups[3].Value
$build = [int]$match.Groups[4].Value

Write-Host "`nCurrent version: $major.$minor.$patch+$build" -ForegroundColor Cyan
Write-Host ''
Write-Host '1. Build only'
Write-Host '2. Patch bump'
Write-Host '3. Minor bump'
Write-Host '4. Major bump'

$choice = Read-Host "`nChoose version bump"

switch ($choice) {
    '1' { }
    '2' { $patch++ }
    '3' { $minor++; $patch = 0 }
    '4' { $major++; $minor = 0; $patch = 0 }
    default { throw 'Invalid selection. No changes made.' }
}

$build++
$newVersion = "$major.$minor.$patch+$build"

Write-Host "`nNew version: $newVersion" -ForegroundColor Green

$confirmation = Read-Host 'Update pubspec.yaml and build APK? (y/n)'

if ($confirmation -notin @('y', 'Y')) {
    Write-Host 'Cancelled. No changes made.'
    return
}

$newContent = [regex]::Replace(
    $content,
    $pattern,
    "version: $newVersion",
    1
)

$encoding = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($pubspecPath, $newContent, $encoding)

Write-Host "`nBuilding release APK..." -ForegroundColor Cyan

try {
    flutter build apk --release

    if ($LASTEXITCODE -ne 0) {
        throw 'Flutter release build failed.'
    }

    if (-not (Test-Path $apkPath)) {
        throw 'Build completed but APK was not found.'
    }

    $apk = Get-Item $apkPath

    Write-Host "`nBuild successful!" -ForegroundColor Green
    Write-Host "Version: $newVersion"
    Write-Host "APK: $($apk.FullName)"
    Write-Host "Size: $([math]::Round($apk.Length / 1MB, 2)) MB"
}
catch {
    [System.IO.File]::WriteAllText($pubspecPath, $content, $encoding)
    throw
}
