$ErrorActionPreference = "Stop"

Write-Host "NEON PULSE 3D - Setup Script" -ForegroundColor Magenta
Write-Host "================================" -ForegroundColor Magenta

# 1. Verifica Flutter
Write-Host ""
Write-Host "[1/5] Verificando Flutter..." -ForegroundColor Cyan
$env:PATH += ";C:\flutter\bin"
try {
    flutter --version | Out-Null
    Write-Host "OK - Flutter encontrado" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Flutter no encontrado en C:\flutter\bin" -ForegroundColor Red
    exit 1
}

# 2. Inicializar proyecto Flutter (genera android/, ios/, etc.)
Write-Host ""
Write-Host "[2/5] Inicializando proyecto Flutter..." -ForegroundColor Cyan
flutter create --org com.neonpulse --project-name neon_pulse_3d . --platforms android,ios
Write-Host "OK - Proyecto Flutter inicializado" -ForegroundColor Green

# 3. Instalar dependencias
Write-Host ""
Write-Host "[3/5] Instalando dependencias..." -ForegroundColor Cyan
flutter pub get
Write-Host "OK - Dependencias instaladas" -ForegroundColor Green

# 4. Flutter doctor
Write-Host ""
Write-Host "[4/5] Diagnostico del entorno..." -ForegroundColor Cyan
flutter doctor

# 5. Proximos pasos
Write-Host ""
Write-Host "[5/5] Proximos pasos:" -ForegroundColor Cyan
Write-Host ""
Write-Host "CONFIGURACION REQUERIDA:" -ForegroundColor Yellow
Write-Host "  1. Edita lib/main.dart con tu SUPABASE_URL y SUPABASE_ANON_KEY"
Write-Host "  2. Ejecuta supabase/schema.sql en tu proyecto Supabase"
Write-Host "  3. Configura RevenueCat (API key)"
Write-Host ""
Write-Host "PARA CORRER:" -ForegroundColor Green
Write-Host "  flutter run"
Write-Host ""
Write-Host "PARA ANDROID:" -ForegroundColor Green
Write-Host "  flutter run -d android"
