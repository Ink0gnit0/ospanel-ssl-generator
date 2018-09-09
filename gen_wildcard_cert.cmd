@echo off
setlocal EnableDelayedExpansion

cd %~dp0
call env_vars.cmd

set /p dname=Enter base domain name: || set dname=test
set cname=*.%dname%

echo [trust_cert] > %TMP_DIR%\%dname%.cnf
echo keyUsage=digitalSignature,keyEncipherment,dataEncipherment >> %TMP_DIR%\%dname%.cnf
echo extendedKeyUsage=serverAuth,clientAuth >> %TMP_DIR%\%dname%.cnf

rem Generate key
openssl genrsa -out %CERTS_DIR%\%dname%.key %RSA_KEY_BITS%

rem Generate certificate request
openssl req -sha256 -new -key %CERTS_DIR%\%dname%.key -out %TMP_DIR%\%dname%.csr -subj /emailAddress=%KEY_EMAIL%/C="%KEY_COUNTRY%"/stateOrProvinceName="%KEY_STATE%"/L="%KEY_CITY%"/O="%KEY_ORG%"/OU="%KEY_ORG_UNIT%"/CN=%cname%

rem Sign with trusted domain certificate
openssl x509 -sha256 -req -days %VALID_DAYS% -in %TMP_DIR%\%dname%.csr -extfile %TMP_DIR%\%dname%.cnf -extensions trust_cert -CA %CA_DIR%/trusted.crt -CAkey %CA_DIR%/trusted.key -out %CERTS_DIR%\%dname%.crt

rem Print certificate purpose
openssl x509 -in %CERTS_DIR%\%dname%.crt -noout -purpose 

openssl pkcs12 -export -out %CERTS_DIR%\%dname%.pfx -inkey %CERTS_DIR%\%dname%.key -in %CERTS_DIR%\%dname%.crt -certfile %CA_DIR%/trusted.crt -passout pass:%PFX_PASS%

del %TMP_DIR%\%dname%.csr
del %TMP_DIR%\%dname%.cnf

pause