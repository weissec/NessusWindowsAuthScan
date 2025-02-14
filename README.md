# NessusWindowsAuthScan

Windows script to deploy the necessary configuration changes to allow Nessus authenticated scans.
The script automates some configuration changes necessary for Tenable Nessus to perform credentialed checks.
More information about the necessary configuration changes can be found here: https://docs.tenable.com/nessus/Content/CredentialedChecksOnWindows.htm

The script creates a backup of the original configuration/settings so that these can be reverted after the scans.

#### How to run:
Simply download the .bat files and double click on them to run them.
To create a backup of the configuration and prepare the system for a scan, run: Nessus-Pre-Scan.bat
To revert to the original configuration after a scan, run: Nessus-Post-Scan.bat

#### Requirements: 
The script must be run as an administrator. 
