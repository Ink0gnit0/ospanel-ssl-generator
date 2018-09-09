@echo off
setlocal

cd %~dp0
call env_vars.cmd

echo [trust_cert] > %CA_DIR%\trusted.cnf
echo authorityKeyIdentifier=keyid,issuer:always >> %CA_DIR%\trusted.cnf
echo subjectKeyIdentifier=hash >> %CA_DIR%\trusted.cnf
echo basicConstraints=CA:true >> %CA_DIR%\trusted.cnf
echo [ca] >> %CA_DIR%\trusted.cnf
echo dir=%CA_DIR% >> %CA_DIR%\trusted.cnf
echo default_ca=CA_default >> %CA_DIR%\trusted.cnf
echo database=$dir/index.txt >> %CA_DIR%\trusted.cnf
echo default_md=default >> %CA_DIR%\trusted.cnf
echo default_crl_days=30 >> %CA_DIR%\trusted.cnf
echo crlnumber=$dir/crlnumber >> %CA_DIR%\trusted.cnf
echo [CA_default] >> %CA_DIR%\trusted.cnf
echo dir=%CA_DIR% >> %CA_DIR%\trusted.cnf
echo certs=$dir >> %CA_DIR%\trusted.cnf
echo crl_dir=$dir >> %CA_DIR%\trusted.cnf
echo database=$dir/index.txt >> %CA_DIR%\trusted.cnf
echo crlnumber=$dir/crlnumber >> %CA_DIR%\trusted.cnf
echo x509_extensions=usr_cert >> %CA_DIR%\trusted.cnf
echo name_opt=ca_default >> %CA_DIR%\trusted.cnf
echo cert_opt=ca_default >> %CA_DIR%\trusted.cnf
echo default_days=365 >> %CA_DIR%\trusted.cnf
echo default_crl_days=30 >> %CA_DIR%\trusted.cnf
echo default_md=default >> %CA_DIR%\trusted.cnf
echo preserve=no >> %CA_DIR%\trusted.cnf
echo [ new_oids ] >> %CA_DIR%\trusted.cnf
echo businessCategory=2.5.4.15 >> %CA_DIR%\trusted.cnf
echo streetAddress=2.5.4.9 >> %CA_DIR%\trusted.cnf
echo stateOrProvinceName=2.5.4.8 >> %CA_DIR%\trusted.cnf
echo countryName=2.5.4.6 >> %CA_DIR%\trusted.cnf
echo jurisdictionOfIncorporationStateOrProvinceName=1.3.6.1.4.1.311.60.2.1.2 >> %CA_DIR%\trusted.cnf
echo jurisdictionOfIncorporationLocalityName=1.3.6.1.4.1.311.60.2.1.1 >> %CA_DIR%\trusted.cnf
echo jurisdictionOfIncorporationCountryName=1.3.6.1.4.1.311.60.2.1.3 >> %CA_DIR%\trusted.cnf

openssl genrsa -out %CA_DIR%\trusted.key %KEY_SIZE%

openssl req -sha256 -new -utf8 -key %CA_DIR%/trusted.key -out %TMP_DIR%/trusted.csr -subj /emailAddress=%KEY_EMAIL%/C="%KEY_COUNTRY%"/stateOrProvinceName="%KEY_STATE%"/L="%KEY_CITY%"/O="%KEY_ORG%"/OU="%KEY_ORG_UNIT%"/CN="%KEY_CA_NAME%"

openssl x509 -sha256 -req -extfile %CA_DIR%/trusted.cnf -extensions trust_cert -days %CA_VALID_DAYS% -in %TMP_DIR%/trusted.csr -signkey %CA_DIR%/trusted.key -CAcreateserial -out %CA_DIR%/trusted.crt

openssl x509 -in %CA_DIR%/trusted.crt -noout -purpose

FOR /F "tokens=* USEBACKQ" %%F IN (`openssl x509 -in %CA_DIR%/trusted.crt -serial -noout `) DO (
SET _serial=%%F
)
echo %_serial:~7% > %CA_DIR%\trusted.srl

del %TMP_DIR%\trusted.*

pause