@echo off
setlocal

cd %~dp0
call env_vars.cmd

openssl crl -in %CA_DIR%/revoked.crl -text -noout

pause