@echo off
setlocal EnableDelayedExpansion

cd %~dp0
call env_vars.cmd

set /p dname=Enter domain name: || set dname=test

echo [trust_cert] > %TMP_DIR%\%dname%.cnf
echo subjectAltName=@alt_names >> %TMP_DIR%\%dname%.cnf
echo keyUsage=digitalSignature,keyEncipherment,dataEncipherment >> %TMP_DIR%\%dname%.cnf
echo extendedKeyUsage=serverAuth,clientAuth >> %TMP_DIR%\%dname%.cnf
rem echo authorityInfoAccess=OCSP;URI:http://localhost >> %TMP_DIR%\%dname%.cnf
rem echo crlDistributionPoints=URI:http://localhost/trusted.crl >> %TMP_DIR%\%dname%.cnf
echo [alt_names] >> %TMP_DIR%\%dname%.cnf
echo DNS.1=%dname% >> %TMP_DIR%\%dname%.cnf
echo DNS.2 = %dname%.ospanel.io >> %TMP_DIR%\%dname%.cnf

set /a "alias_nr = 2"
:another_alias
set /p _q="Add an alias? [press Y to continue, N to skip]: " || set _q=n

if /I "%_q%" == "y" (
	set /p aname="Enter alias name [you can use wildcard]: " || set aname=www
	echo DNS.%alias_nr%=!aname! >> %TMP_DIR%\%dname%.cnf
) else goto continue_gen

set /a "alias_nr+=1"
goto another_alias

:continue_gen
openssl genrsa -out %CERTS_DIR%\%dname%.key %RSA_KEY_BITS%
openssl req -sha256 -new -key %CERTS_DIR%\%dname%.key -out %TMP_DIR%\%dname%.csr -subj /emailAddress=%KEY_EMAIL%/C="%KEY_COUNTRY%"/stateOrProvinceName="%KEY_STATE%"/L="%KEY_CITY%"/O="%KEY_ORG%"/OU="%KEY_ORG_UNIT%"/CN=%dname%

openssl x509 -sha256 -req -days %VALID_DAYS% -in %TMP_DIR%\%dname%.csr -extfile %TMP_DIR%\%dname%.cnf -extensions trust_cert -CA %CA_DIR%/trusted.crt -CAkey %CA_DIR%/trusted.key -out %CERTS_DIR%\%dname%.crt

openssl x509 -in %CERTS_DIR%\%dname%.crt -noout -purpose

del %TMP_DIR%\%dname%.csr
del %TMP_DIR%\%dname%.cnf

pause