@echo off

start cmd /k "cd /d %~dp0\server && php artisan serve"
start cmd /k "cd /d %~dp0\server && npm run dev"
start cmd /k "cd /d %~dp0\server && php artisan dump-server"

cd /d %~dp0\client
start cmd /k "dart run build_runner watch -d"
