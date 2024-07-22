@echo off

cd "%~dp0"

set IMG_NAME=pulseview-cc-mingw

del %IMG_NAME%.tar.7z 2>nul

docker save %IMG_NAME%:latest -o %IMG_NAME%.tar
"C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 -mmt=on %IMG_NAME%.tar.7z %IMG_NAME%.tar
del %IMG_NAME%.tar
