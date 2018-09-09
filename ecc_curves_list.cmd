@echo off
setlocal

cd %~dp0
call env_vars.cmd

openssl ecparam -list_curves > %TMP_DIR%\ecc_curves.txt

echo You can view curves list in file %TMP_DIR%\ecc_curves.txt

pause