@echo off
setlocal EnableDelayedExpansion

cd %~dp0
call env_vars.cmd

set dname=server
set server_ip=10.8.0.5
set CERTS_DIR=%OSPANEL_DIR%\userdata\config\cert_files

echo [trust_cert] > %TMP_DIR%\%dname%.cnf
echo subjectAltName=@alt_names >> %TMP_DIR%\%dname%.cnf
echo keyUsage=digitalSignature,keyEncipherment,dataEncipherment >> %TMP_DIR%\%dname%.cnf
echo extendedKeyUsage=serverAuth,clientAuth >> %TMP_DIR%\%dname%.cnf
rem echo authorityInfoAccess=OCSP;URI:http://localhost >> %TMP_DIR%\%dname%.cnf
rem echo crlDistributionPoints=URI:http://localhost/trusted.crl >> %TMP_DIR%\%dname%.cnf
echo [alt_names] >> %TMP_DIR%\%dname%.cnf

set /a alias_nr=1
for /f "tokens=*" %%G in ('dir %DOMAINS_DIR% /b') do (
	echo DNS.!alias_nr! = %%G >> %TMP_DIR%\%dname%.cnf
	set /a alias_nr+=1
)

echo IP.1 = 127.0.0.1 >> %TMP_DIR%\%dname%.cnf
echo IP.2 = %server_ip% >> %TMP_DIR%\%dname%.cnf

openssl genrsa -out %CERTS_DIR%\%dname%.key %RSA_KEY_BITS%
openssl req -sha256 -new -key %CERTS_DIR%\%dname%.key -out %TMP_DIR%\%dname%.csr -subj /emailAddress=%KEY_EMAIL%/C="%KEY_COUNTRY%"/stateOrProvinceName="%KEY_STATE%"/L="%KEY_CITY%"/O="%KEY_ORG%"/OU="%KEY_ORG_UNIT%"/CN=%dname%

openssl x509 -sha256 -req -days %VALID_DAYS% -in %TMP_DIR%\%dname%.csr -extfile %TMP_DIR%\%dname%.cnf -extensions trust_cert -CA %CA_DIR%/trusted.crt -CAkey %CA_DIR%/trusted.key -out %CERTS_DIR%\%dname%.crt

openssl x509 -in %CERTS_DIR%\%dname%.crt -noout -purpose

del %TMP_DIR%\%dname%.csr
del %TMP_DIR%\%dname%.cnf

pause