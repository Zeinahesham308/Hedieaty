# Set paths
$adbPath = "C:\Users\zeina\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$flutterProjectPath = "C:\Users\zeina\StudioProjects\Hedieaty"
$screenRecordingPath = "C:\Users\zeina\StudioProjects\Hedieaty\example\screen_second.mp4"

# Navigate to the Flutter project directory
Set-Location -Path $flutterProjectPath

# Check if adb is working and device is connected
$devices = & $adbPath devices

# Kill any existing screenrecord process
& $adbPath shell "killall -2 screenrecord" 2>$null

# Remove any existing recording file on device
& $adbPath shell "rm /sdcard/screen_record.mp4" 2>$null

# Grant necessary permissions
& $adbPath appops set android SYSTEM_ALERT_WINDOW allow
& $adbPath shell settings put global hidden_api_policy 1

# Start screen recording
Write-Host "Starting screen recording..." -ForegroundColor Green
$screenrecord = Start-Process -NoNewWindow -FilePath $adbPath -ArgumentList "shell", "screenrecord", "/sdcard/screen_record.mp4" -PassThru

# Small delay to ensure recording has started
Start-Sleep -Seconds 2

# Run the Flutter integration test
Write-Host "Running Flutter integration test..." -ForegroundColor Green
flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/E2E_test.dart

# Stop the recording by killing the screenrecord process
Write-Host "Stopping screen recording..." -ForegroundColor Green
& $adbPath shell "killall -2 screenrecord"

# Wait a moment for the file to be properly saved
Start-Sleep -Seconds 3

# Check if the recording file exists on the device
$fileExists = & $adbPath shell "ls /sdcard/screen_record.mp4 2>/dev/null"
if (-not $fileExists) {
    Write-Host "Error: Recording file not found on device" -ForegroundColor Red
    exit 1
}

# Pull the recording from the device
Write-Host "Pulling recording from device..." -ForegroundColor Green
& $adbPath pull /sdcard/screen_record.mp4 $screenRecordingPath

if (Test-Path $screenRecordingPath) {
    Write-Host "Screen recording saved successfully to: $screenRecordingPath" -ForegroundColor Green
} else {
    Write-Host "Error: Failed to save recording locally" -ForegroundColor Red
}

# Clean up the file from the device
& $adbPath shell "rm /sdcard/screen_record.mp4"
