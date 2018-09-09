@echo off
setlocal

cd %~dp0
call env_vars.cmd

set /p dname=Enter domain name to revoke: || set dname=test

if not exist "%CA_DIR%/index.txt" (
type nul >"%CA_DIR%/index.txt"
type nul >"%CA_DIR%/index.txt.attr"
)

if exist "%CERTS_DIR%\%dname%.crt" (
	openssl ca -verbose -config %CA_DIR%/trusted.cnf -cert %CA_DIR%/trusted.crt -keyfile %CA_DIR%/trusted.key -revoke %CERTS_DIR%\%dname%.crt

	openssl ca -gencrl -verbose -config %CA_DIR%/trusted.cnf -name ca -cert %CA_DIR%/trusted.crt -keyfile %CA_DIR%/trusted.key -out %CA_DIR%/revoked.crl

	copy /Y "%CA_DIR%\revoked.crl" "%DOMAINS_DIR%\localhost"
)
openssl crl -in %CA_DIR%/revoked.crl -text -noout

pause