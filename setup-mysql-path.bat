@echo off
REM Quick setup script for running MySQL commands on Windows
REM This sets up the PATH for MySQL commands

setx PATH "%PATH%;C:\Program Files\MySQL\MySQL Server 9.6\bin"

echo MySQL bin directory added to PATH
echo You can now use 'mysql' command directly in new PowerShell/CMD windows
pause

