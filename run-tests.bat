@echo off
setlocal
cd /d "%~dp0"
set PATH=C:\msys64\ucrt64\bin;%PATH%
if not exist build mkdir build
g++ -std=c++17 -Wall tests\test_store.cpp backend\classroom_store.cpp -o build\tests.exe -static
if errorlevel 1 (
  pause
  exit /b 1
)
build\tests.exe
pause
