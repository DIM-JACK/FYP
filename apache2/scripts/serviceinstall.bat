@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove

"C:/Bitnami/processmaker-3.2.1-0/apache2\bin\httpd.exe" -k install -n "processmakerApache" -f "C:/Bitnami/processmaker-3.2.1-0/apache2\conf\httpd.conf"

net start processmakerApache >NUL
goto end

:remove
rem -- STOP SERVICE BEFORE REMOVING

net stop processmakerApache >NUL
"C:/Bitnami/processmaker-3.2.1-0/apache2\bin\httpd.exe" -k uninstall -n "processmakerApache"

:end
exit
