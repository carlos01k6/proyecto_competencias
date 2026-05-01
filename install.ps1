Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Instalando proyecto completo..." -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

Write-Host "`n1. Instalando dependencias Backend..." -ForegroundColor Yellow
cd backend
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
cd ..

Write-Host "`n2. Instalando dependencias Frontend..." -ForegroundColor Yellow
cd frontend
npm install
cd ..

Write-Host "`n3. Creando usuario de prueba..." -ForegroundColor Yellow
python create_user.py

Write-Host "`n=====================================" -ForegroundColor Green
Write-Host "Instalacion completada!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host "`nPara ejecutar:" -ForegroundColor Cyan
Write-Host "Terminal 1 (Backend): cd backend && .\venv\Scripts\activate && python wsgi.py" -ForegroundColor White
Write-Host "Terminal 2 (Frontend): cd frontend && npm run dev" -ForegroundColor White
