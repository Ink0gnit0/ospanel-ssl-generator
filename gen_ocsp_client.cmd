@echo off
setlocal

cd %~dp0
call env_vars.cmd

echo Generating OCSP response...
for /f "tokens=*" %%G in ('dir /b %CERTS_DIR%\*.crt') do (
	echo Certificate '%%G' checking...
	openssl ocsp -issuer %CA_DIR%/trusted.crt -CAfile %CA_DIR%/trusted.crt -cert %CERTS_DIR%\%%G -url http://localhost:%OCSP_PORT%/ -text
)

pause