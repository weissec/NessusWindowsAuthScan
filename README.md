# Nessus Windows Credentialed Scan Preparation Script

Windows script to deploy the necessary configuration changes to allow Nessus authenticated scans.
The script automates some configuration changes necessary for Tenable Nessus to perform credentialed checks.

More information about the necessary configuration changes can be found here: https://docs.tenable.com/nessus/Content/CredentialedChecksOnWindows.htm

The script creates a backup of the original configuration/settings so that these can be reverted after the scans.

#### How to run:
Simply download the .bat files, right-click on them and select "Run as Administrator".
To create a backup of the configuration and prepare the system for a scan, run: Nessus-Pre-Scan.bat
To revert to the original configuration after a scan, run: Nessus-Post-Scan.bat

#### Requirements: 
The script must be run with administrative privileges.

#### Configuration Changes:
- Enables File and Printer Sharing
- Starts Remote Registry service
- Sets registry key for File and Printer services 
- Sets registry key for Remote and Local access
- Disables Internet Connection Firewall for local LAN or VPN connections
- Disables UAC (User Account Control)
- Enable WMI Service

### Nessus Recommendations:
1. The Windows Management Instrumentation (WMI) service must be enabled on the target. For more information, please see: Introduction to WEBMTEST. Additionally, ensure that ports 49152 through 65535 are open between the scanner and the target, as WMI connections will choose one of these ports to target.
2. The Remote Registry service must be enabled on the target.
3. File & Printer Sharing must be enabled in the target's network configuration.
4. An SMB account must be used that has local administrator rights on the target.
Note: A domain account can be used as long as that account is a local administrator on the devices being scanned.
5. TCP ports 139 and 445 must be open between the Nessus Scanner and the target.
6. Ensure that there are no security policies are in place that blocks access to these services. This can include:
  - Windows Security Policies
  - Antivirus or Endpoint Security rules
  - IPS/IDS
7. The default administrative shares must be enabled.
  - These shares include:
    - IPC$
    - ADMIN$
    - C$
  - The setting that controls this is AutoShareServer (Windows Server) or AutoShareWks (Windows Workstation) which must be set to 1.
  - Windows 10 has the ADMIN$ disabled by default.
  - For all other operating systems, these shares are enabled by default and can cause other issues if disabled. For more information, see http://support.microsoft.com/kb/842715/en-us
