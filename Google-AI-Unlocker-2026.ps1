```powershell
# === Google AI Geo-Unlocker 2026 (NotebookLM + AI Studio + Antigravity) ===
# Запускать от имени администратора!

Write-Host "=== Google AI Geo-Unlocker 2026 ===" -ForegroundColor Cyan
Write-Host "VPN на США уже включён?" -ForegroundColor Yellow
Pause

# Убиваем все процессы Chrome
Get-Process -Name "*chrome*" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 3

$chromeData = "$env:LOCALAPPDATA\Google\Chrome\User Data"

# Очистка Default + всех Profile *
$profiles = Get-ChildItem $chromeData -Directory | Where-Object { $_.Name -like "Default" -or $_.Name -like "Profile *" }

foreach ($profile in $profiles) {
    $path = $profile.FullName
    Write-Host "Очищаем: $path" -ForegroundColor Yellow

    # Критические файлы
    $criticalFiles = @("Cookies", "Login Data", "Login Data-journal", "Web Data", "Preferences",
                       "Secure Preferences", "Local State", "History", "History-journal", "Quarantine")
    foreach ($file in $criticalFiles) {
        $full = Join-Path $path $file
        if (Test-Path $full) { Remove-Item $full -Force -ErrorAction SilentlyContinue }
    }

    # Папки
    $folders = @("Cache", "Code Cache", "GPUCache", "Local Storage", "IndexedDB",
                 "Service Worker", "Session Storage", "Web Applications")
    foreach ($folder in $folders) {
        $fullDir = Join-Path $path $folder
        if (Test-Path $fullDir) { Remove-Item $fullDir -Recurse -Force -ErrorAction SilentlyContinue }
    }
}

# DNS
ipconfig /flushdns | Out-Null
Clear-DnsClientCache -ErrorAction SilentlyContinue

Write-Host "Очистка завершена. Запускаем чистый Chrome..." -ForegroundColor Green

$chromeArgs = @(
    "--incognito",
    "--no-first-run",
    "--disable-sync",
    "--disable-features=OptimizationHints,MediaRouter,Translate,WebRTC",
    "--disable-background-networking",
    "--disable-geolocation",
    "--disable-web-security",
    "--no-pings",
    "--no-default-browser-check",
    "--disable-site-isolation-trials",
    "--disable-component-update",
    "--user-data-dir=$env:TEMP\ChromeCleanAI2026",
    "--user-agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36'",
    "https://notebooklm.google.com",
    "https://aistudio.google.com",
    "https://antigravity.google"
)

try {
    Start-Process "chrome.exe" -ArgumentList $chromeArgs
} catch {
    Write-Host "Chrome не найден. Укажи полный путь:" -ForegroundColor Red
    Write-Host "Start-Process 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList `$chromeArgs" -ForegroundColor White
}

Write-Host "`nГОТОВО!" -ForegroundColor Magenta
Write-Host "• Откроется три вкладки" -ForegroundColor White
Write-Host "• Создай/войди в НОВЫЙ аккаунт (созданный под VPN США)" -ForegroundColor White
Write-Host "• Если Permission Denied — смени сервер VPN и запусти скрипт заново" -ForegroundColor Yellow