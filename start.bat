@echo off

start cmd /k "cd /d %~dp0\server && php artisan serve"

cd /d %~dp0\client
start cmd /k "dart run build_runner watch -d"