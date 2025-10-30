# Clear Vite Cache and Restart Script
# This script clears Vite cache and restarts the dev server

Write-Host "🧹 Clearing Vite cache..." -ForegroundColor Yellow
if (Test-Path "node_modules/.vite") {
    Remove-Item -Recurse -Force "node_modules/.vite"
    Write-Host "✅ Vite cache cleared" -ForegroundColor Green
} else {
    Write-Host "ℹ️  No cache found" -ForegroundColor Cyan
}

Write-Host "`n📋 Current .env configuration:" -ForegroundColor Yellow
Get-Content .env | Select-String "VITE_API"

Write-Host "`n🚀 Starting dev server..." -ForegroundColor Yellow
Write-Host "   After server starts, check browser console for:" -ForegroundColor Cyan
Write-Host "   🔍 Environment Variable Check" -ForegroundColor White
Write-Host "   ✅ Using .env value: http://192.168.1.108:5001" -ForegroundColor Green
Write-Host "`n"

npm run dev

