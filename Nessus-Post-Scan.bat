@echo off 
echo ******************************************************************************
echo ** This batch file will automatically remove all changes and settings       **
echo ** made to this computer for the purposes of the Nessus authenticated scan. **
echo ** The script must be run from the same location as the Nessus-Pre-Scan.bat **
echo ******************************************************************************
echo [!] Please ensure you run this script as Administrator.
echo.
SET runningpath=%~dp0
pause
echo.
echo Restoring original Firewall settings..
netsh advfirewall import "%runningpath%\Settings-Backup\firewall-rules-backup.wfw"

echo Restoring original Remote Registry settings..
REG restore "HKLM\SYSTEM\CurrentControlSet\services\RemoteRegistry" "%runningpath%\Settings-Backup\Nessus-Original-Key-1.hiv"

echo Restoring setting registry key for File and Printer services..
REG restore "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Services\FileAndPrint" "%runningpath%\Settings-Backup\Nessus-Original-Key-2.hiv"
echo (If the last command returned an error, please ignore it.)

echo Restoring original Internet Connection Firewall for LAN or VPN connections settings..
REG restore "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" "%runningpath%\Settings-Backup\Nessus-Original-Key-3.hiv"

echo Restoring original UAC (User Account Control) settings..
REG restore "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system" "%runningpath%\Settings-Backup\Nessus-Original-Key-4.hiv"

echo.
echo All commmands successfully completed. Original configuration restored.
echo You can now delete the scripts and backup folder.
echo.
Pause