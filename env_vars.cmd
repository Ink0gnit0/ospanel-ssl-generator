@echo off
set OSPANEL_DIR=c:\openserver
set GENERATOR_DIR=%OSPANEL_DIR%\certs\generator
set OPENSSL_CONF=%GENERATOR_DIR%\utils\openssl\openssl.cfg
set PATH=%PATH%;%GENERATOR_DIR%\utils\openssl;%GENERATOR_DIR%\utils\signtool
set CERTS_DIR=%OSPANEL_DIR%\certs
set CA_DIR=%GENERATOR_DIR%\ca
set ECC_CA_DIR=%CA_DIR%\ecc
set TMP_DIR=%GENERATOR_DIR%\tmp
set DOMAINS_DIR=%OSPANEL_DIR%\domains\

set VALID_DAYS=730
set RSA_KEY_BITS=2048
set ECC_CURVE_NAME=prime256v1
set PFX_PASS=123456
set OCSP_PORT=8888
set CA_VALID_DAYS=7300

set KEY_COUNTRY=RU
set KEY_STATE=Russian Federation
set KEY_CITY=Moscow
set KEY_ORG=Open Server Panel
set KEY_ORG_UNIT=Software
set KEY_EMAIL=info@ospanel.io
set KEY_CA_NAME=ospanel

mkdir %CERTS_DIR% > nul 2> nul
mkdir %TMP_DIR% > nul 2> nul
mkdir %CA_DIR% > nul 2> nul
mkdir %ECC_CA_DIR% > nul 2> nul