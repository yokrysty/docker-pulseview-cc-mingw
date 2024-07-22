@echo off

cd "%~dp0"

docker build -t pulseview-cc-mingw .
