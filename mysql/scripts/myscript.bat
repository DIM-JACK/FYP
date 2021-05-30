@echo off
"C:\Bitnami\processmaker-3.2.1-0/mysql\bin\mysql.exe" --defaults-file="C:\Bitnami\processmaker-3.2.1-0/mysql\my.ini" -u root -e "UPDATE mysql.user SET Password=password('%1') WHERE User='root';"
"C:\Bitnami\processmaker-3.2.1-0/mysql\bin\mysql.exe" --defaults-file="C:\Bitnami\processmaker-3.2.1-0/mysql\my.ini" -u root -e "DELETE FROM mysql.user WHERE User='';"
"C:\Bitnami\processmaker-3.2.1-0/mysql\bin\mysql.exe" --defaults-file="C:\Bitnami\processmaker-3.2.1-0/mysql\my.ini" -u root -e "FLUSH PRIVILEGES;"
