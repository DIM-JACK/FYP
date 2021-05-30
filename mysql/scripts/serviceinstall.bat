@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove

"C:\Bitnami\processmaker-3.2.1-0/mysql\bin\mysqld.exe" --install "processmakerMySQL" --defaults-file="C:\Bitnami\processmaker-3.2.1-0/mysql\my.ini"

net start "processmakerMySQL" >NUL
goto end

:remove
rem -- STOP SERVICES BEFORE REMOVING

net stop "processmakerMySQL" >NUL
"C:\Bitnami\processmaker-3.2.1-0/mysql\bin\mysqld.exe" --remove "processmakerMySQL"

:end
exit
