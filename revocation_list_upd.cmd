@echo off
setlocal

cd %~dp0
call env_vars.cmd

if not exist "%CA_DIR%\index.txt" (
type nul > %CA_DIR%\index.txt
type nul > %CA_DIR%\index.txt.attr
)
if not exist "%CA_DIR%\crlnumber" (
echo 01> %CA_DIR%\crlnumber
)

openssl ca -gencrl -verbose -config %CA_DIR%/trusted.cnf -cert %CA_DIR%/trusted.crt -keyfile %CA_DIR%/trusted.key -out %CA_DIR%/revoked.crl

openssl crl -in %CA_DIR%/revoked.crl -text -noout

pause