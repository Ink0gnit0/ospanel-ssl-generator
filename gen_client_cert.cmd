@echo off
setlocal

cd %~dp0
call env_vars.cmd

set /p cname=Enter client name: || set cname=client

echo [trust_cert] > %TMP_DIR%\%cname%.cnf
echo keyUsage=digitalSignature,keyEncipherment >> %TMP_DIR%\%cname%.cnf
echo extendedKeyUsage=clientAuth >> %TMP_DIR%\%cname%.cnf

openssl genrsa -out %CERTS_DIR%\%cname%.key %RSA_KEY_BITS%
openssl req -sha256 -new -utf8 -key %CERTS_DIR%\%cname%.key -out %TMP_DIR%\%cname%.csr -subj /emailAddress=%KEY_EMAIL%/C="%KEY_COUNTRY%"/stateOrProvinceName="%KEY_STATE%"/L="%KEY_CITY%"/O="%KEY_ORG%"/OU="%KEY_ORG_UNIT%"/CN=%cname%
openssl x509 -sha256 -req -days %VALID_DAYS% -in %TMP_DIR%\%cname%.csr -extfile %TMP_DIR%\%cname%.cnf -extensions trust_cert -CA %CA_DIR%/trusted.crt -CAkey %CA_DIR%/trusted.key -out %CERTS_DIR%\%cname%.crt

openssl x509 -in %CERTS_DIR%\%cname%.crt -noout -purpose

openssl pkcs12 -export -out %CERTS_DIR%\%cname%.pfx -inkey %CERTS_DIR%\%cname%.key -in %CERTS_DIR%\%cname%.crt -certfile %CA_DIR%/trusted.crt -passout pass:%PFX_PASS%

del %TMP_DIR%\%cname%.csr
del %TMP_DIR%\%cname%.cnf

pause