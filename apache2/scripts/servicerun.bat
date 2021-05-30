@echo off
rem START or STOP Apache Service
rem --------------------------------------------------------
rem Check if argument is STOP or START

if not ""%1"" == ""START"" goto stop

net start processmakerApache
goto end

:stop

"C:/Bitnami/processmaker-3.2.1-0/apache2\bin\httpd.exe" -n "processmakerApache" -k stop

:end
exit
