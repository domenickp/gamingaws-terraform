<powershell>

function Disable-WindowsFirewall {
    # Show hidden files, show file extentions, and show
    # system files, a.k.a. SuperHidden files (snrk)
    # and bounce Explorer after the changes are made.
    # http://stackoverflow.com/questions/4491999/configure-windows-explorer-folder-options-through-powershell#8110982
    $explorerKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Set-ItemProperty $explorerKey Hidden 1
    Set-ItemProperty $explorerKey HideFileExt 0
    Set-ItemProperty $explorerKey ShowSuperHidden 1
    Stop-Process -Name Explorer -Force
}
function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Rundll32 iesetup.dll, IEHardenLMSettings,1,True
    Rundll32 iesetup.dll, IEHardenUser,1,True
    Rundll32 iesetup.dll, IEHardenAdmin,1,True
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    Stop-Process -Name Explorer -Force
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}
function Disable-UserAccessControl {
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000 -Force
    Write-Host "User Access Control (UAC) has been disabled." -ForegroundColor Green    
}
function Reload-EnvironmentVars {
    # After chocolatey is installed, reload the path to be able to run choco commands.
    # http://stackoverflow.com/questions/14381650/how-to-update-windows-powershell-session-environment-variables-from-registry
    foreach($level in "Machine","User") {
       [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
          # For Path variables, append the new values, if they're not already in there
          if($_.Name -match 'Path$') { 
             $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
          }
          $_
       } | Set-Content -Path { "Env:$($_.Name)" }
    }
}

Rename-Computer -NewName gaming-pc

Disable-UserAccessControl
Disable-InternetExplorerESC
Disable-WindowsFirewall

# Required for chocolatey installation
Set-ExecutionPolicy RemoteSigned -Force

# Disable firewall
Set-NetFirewallProfile -Profile * -Enabled False

# Install chocolatey.  Yeah, yeah, curl pipe sh is bad.
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

# Adding the openssl path ahead of the env var reload, chicken+egg problem
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\OpenSSL\bin", [EnvironmentVariableTarget]::Machine)

Reload-EnvironmentVars

# This doesn't work, need to figure out why
#choco install geforce-game-ready-driver-win7

# Install steam, openvpn, openssl, and firefox.
# I chose firefox here because google chrome installs an update
#  service that is marked failed by Server Manager.  Annoying.
choco install -y steam openvpn firefox openssl.light

# Enable sound in server 2012
Set-Service Audiosrv -startuptype "Automatic"
Start-Service Audiosrv

# Stage installer files
# Needs to be manually installed at the moment
iwr -OutFile C:\Users\Administrator\Desktop\razer-surround.exe http://www.razerzone.com/surround/download
iwr -OutFile C:\Users\Administrator\Desktop\hamachi.msi https://secure.logmein.com/hamachi.msi
iwr -OutFile C:\Users\Administrator\Desktop\directx_Jun2010_redist.exe https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe
iwr -OutFile C:\Users\Administrator\Desktop\X_Audio_Input.zip http://www.win2012workstation.com/wp-content/uploads/2012/08/X_Audio_Input.zip

# Blow away the basic display driver to force the use of the nvidia driver
takeown /f C:\Windows\System32\Drivers\BasicDisplay.sys
icacls C:\Windows\System32\Drivers\BasicDisplay.sys /grant:r Administrator:F
del C:\Windows\System32\Drivers\BasicDisplay.sys

</powershell>
