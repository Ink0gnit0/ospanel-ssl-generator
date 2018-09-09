@echo off
setlocal

cd %~dp0
call env_vars.cmd

echo Running OCSP server...
openssl ocsp -index %CA_DIR%/index.txt -CA %CA_DIR%/trusted.crt -rsigner %CA_DIR%/trusted.crt -rkey %CA_DIR%/trusted.key -port 0.0.0.0:%OCSP_PORT%

pause