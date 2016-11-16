<powershell>

Rename-Computer -NewName gaming-pc

# Required for chocolatey installation
Set-ExecutionPolicy RemoteSigned -Force

# Install chocolatey.  Yeah, yeah, curl pipe sh is bad.
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

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

#choco install geforce-game-ready-driver-win7
choco install -y steam

Restart-Computer

</powershell>
