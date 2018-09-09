@echo off
setlocal

cd %~dp0
call env_vars.cmd

set /p dname=Enter domain name: || set dname=test

rem for /f "delims=[] tokens=2" %%a in ('ping %dname% -n 1 ^| findstr "["') do (set domain_ip=%%a)

echo [trust_cert] > %TMP_DIR%\%dname%.cnf
echo subjectAltName=@alt_names >> %TMP_DIR%\%dname%.cnf
echo keyUsage=digitalSignature,keyEncipherment,dataEncipherment >> %TMP_DIR%\%dname%.cnf
echo extendedKeyUsage=serverAuth,clientAuth >> %TMP_DIR%\%dname%.cnf
rem echo authorityInfoAccess=OCSP;URI:http://localhost >> %TMP_DIR%\%dname%.cnf
rem echo crlDistributionPoints=URI:http://localhost/trusted.crl >> %TMP_DIR%\%dname%.cnf
echo [alt_names] >> %TMP_DIR%\%dname%.cnf
echo DNS.1 = %dname% >> %TMP_DIR%\%dname%.cnf
echo DNS.2 = %dname%.ospanel.io >> %TMP_DIR%\%dname%.cnf
rem echo IP.1 = %domain_ip% >> %TMP_DIR%\%dname%.cnf

openssl genrsa -out %CERTS_DIR%\%dname%.key %RSA_KEY_BITS%
openssl req -sha256 -new -utf8 -key %CERTS_DIR%\%dname%.key -out %TMP_DIR%\%dname%.csr -subj /emailAddress=%KEY_EMAIL%/C="%KEY_COUNTRY%"/stateOrProvinceName="%KEY_STATE%"/L="%KEY_CITY%"/O="%KEY_ORG%"/OU="%KEY_ORG_UNIT%"/CN=%dname%
rem Для создания самоподписанного сертификата
rem openssl x509 -sha256 -req -days %VALID_DAYS% -in %TMP_DIR%\%dname%.csr -signkey %CERTS_DIR%\%dname%.key -out %CERTS_DIR%\%dname%.crt
rem Для создания сертификата, подписанного доверенным сертификатом
openssl x509 -sha256 -req -days %VALID_DAYS% -in %TMP_DIR%\%dname%.csr -extfile %TMP_DIR%\%dname%.cnf -extensions trust_cert -CA %CA_DIR%/trusted.crt -CAkey %CA_DIR%/trusted.key -out %CERTS_DIR%\%dname%.crt

openssl x509 -in %CERTS_DIR%\%dname%.crt -noout -purpose

rem openssl pkcs12 -export -out %CERTS_DIR%\%dname%.pfx -inkey %CERTS_DIR%\%dname%.key -in %CERTS_DIR%\%dname%.crt -certfile %CA_DIR%/trusted.crt -passout pass:%PFX_PASS%

del %TMP_DIR%\%dname%.csr
del %TMP_DIR%\%dname%.cnf

pause