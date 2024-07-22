### PulseView mingw cross crompile using docker on Windows



- x64 only (anyone still using x86?), but can be adapted for x86

- contains scripts to build with Cypress FX3 support, but not tested, since I am still waiting for the board :)

- I mainly created this image to build PulseView with Cypress FX3 support, but can also be used with sigrok-util

  

**Requirements:**

- Docker Desktop using Linux containers
- 7zip (optional) installed at C:\Program Files\7-Zip
- internet connection



**Build docker image** (or download a prebuilt one from releases and import using docker load):

- run **build_docker_image.cmd**



**Export docker image:**

- run **export_docker_image.cmd**



**Build PulseView with Cypress FX3 support:**

- add **cypress-fx3.fw** file to current directory

- run **build_pulseview_incl_fx3_installer.cmd**
- pulseview-*-installer.exe will be copied to current directory