@echo off

cd "%~dp0"

docker run --rm -it -v %cd%:/host:rw pulseview-cc-mingw /root/sigrok-fx3/sigrok-cross-mingw
