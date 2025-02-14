cls
@echo off 
echo ****************************************************************************
echo ** This batch file will automatically execute a series of commands that   **
echo ** will allow a Nessus scan to carry out a credentialed vulnerability     **
echo ** assessment against this machine. Please remember to run the Post-Scan  **
echo ** the Post-Scan script once the audit has been completed.                **
echo ****************************************************************************
echo [!] Please ensure you run this script as Administrator.
echo.

SET runningpath=%~dp0

pause
echo.
echo Saving Current System Settings..
mkdir %runningpath%\Settings-Backup
netsh advfirewall export "%runningpath%\Settings-Backup\firewall-rules-backup.wfw"
REG save "HKLM\SYSTEM\CurrentControlSet\services\RemoteRegistry" "%runningpath%\Settings-Backup\Nessus-Original-Key-1.hiv"
REG save "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Services\FileAndPrint" "%runningpath%\Settings-Backup\Nessus-Original-Key-2.hiv"
echo (If the last command returned an error, please ignore it.)
REG save "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" "%runningpath%\Settings-Backup\Nessus-Original-Key-3.hiv"
REG save "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system" "%runningpath%\Settings-Backup\Nessus-Original-Key-4.hiv"

:: Save the current state of the WMI service
sc query winmgmt > "%runningpath%\Settings-Backup\wmi_state.txt"
findstr /C:"RUNNING" "%runningpath%\Settings-Backup\wmi_state.txt" >nul
if %errorlevel% equ 0 (
    set WMI_ORIGINAL_STATE=RUNNING
) else (
    set WMI_ORIGINAL_STATE=STOPPED
)

:: Save the current start type of the WMI service
sc qc winmgmt | findstr /C:"DEMAND_START" >nul
if %errorlevel% equ 0 (
    set WMI_ORIGINAL_START_TYPE=DEMAND_START
) else (
    sc qc winmgmt | findstr /C:"AUTO_START" >nul
    if %errorlevel% equ 0 (
        set WMI_ORIGINAL_START_TYPE=AUTO_START
    ) else (
        set WMI_ORIGINAL_START_TYPE=UNKNOWN
    )
)

:: Save the WMI state to a file for the Post-Scan script
echo %WMI_ORIGINAL_STATE% > "%runningpath%\Settings-Backup\wmi_original_state.txt"
echo %WMI_ORIGINAL_START_TYPE% >> "%runningpath%\Settings-Backup\wmi_original_state.txt"

echo.
echo [ATTENTION] Original system configuration saved. Do not delete the following folder:
echo %runningpath%Settings-Backup\
echo.

:: Configuration Changes:

echo [-] Enabling File and Printer Sharing
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes

:: Registry changes:

echo [-] Starting Remote Registry
REG add "HKLM\SYSTEM\CurrentControlSet\services\RemoteRegistry" /v Start /t REG_DWORD /d 2 /f

echo [-] Setting registry key for File and Printer services 
REG add "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Services\FileAndPrint" /v Enabled /t REG_DWORD /d 1 /f

echo [-] Setting registry key for Remote and Local access
REG add "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Services\FileAndPrint" /v RemoteAddresses /t REG_SZ /d "localsubnet" /f

echo [-] Disabling Internet Connection Firewall for LAN or VPN connections
REG add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /v NC_PersonalFirewallConfig /t REG_DWORD /d 1 /f

echo [-] Disabling UAC (User Account Control)
REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f

:: Enable and start the WMI service
echo [-] Enabling and starting the WMI service...
sc config winmgmt start= auto
sc start winmgmt

echo.
echo [DONE] All commmands successfully completed.
echo You can now close this window and run Nessus.
echo.
Pause