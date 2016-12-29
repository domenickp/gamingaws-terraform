gamingaws-terraform
===================

This stands up an aws-based gaming rig, as described in:
http://lg.io/2015/07/05/revised-and-much-faster-run-your-own-highend-cloud-gaming-service-on-ec2.html

Once the instance is up, you can stream games to a local steam client.

Create a credentials file in the following format, only with live keys, as created in IAM:
```
[default]
aws_access_key_id = NOTAREALACCESSKEYID
aws_secret_access_key = DONTBELIEVETHEHYPE012345678
```

Do not put it in the default location of ~/.aws/credentials, I would recommend tacking -gaming
or similar to the filename to make sure your AWS environments stay separate.  Just tell
variables.tf where you put the file.  Also, leave the 'default' profile name alone,
as terraform seems to have trouble otherwise.

Speaking of which, copy the variable.tf_TEMPLATE to variable.tf, and modify as necessary.
Certainly change the credentials file path, and the subnets if you want to.

Validate the terraform will work as you expect
```
terraform plan
terraform apply
```

Once the ami is launched, the userdata script will:
- Rename the computer
- Disable UAC, IE ESC, and the firewall
- Set the script execution policy to RemoteSigned, for chocolatey
- Install chocolatey, and use it to install openvpn, openssl, firefox, and steam
- Start the windows audio service
- Download the installers for these things, because they don't have a quiet installation option (or I haven't looked for it)
    - Razer surround, to get a virtual sound card
    - Hamachi, because I'm lazy and haven't got openvpn working yet
    - DirectX and audio library installers
- Blow away the standard display driver, so steam is forced to use the nvidia one (not sure if this is necessary)

You will need to do the following (ToDo-Automation):
- Install/Configure Hamachi
  - It is reccommended to create a 'Mesh Network' and join the machine to it
- Install Razer Surround
  - You may want to disable the service 'Razer Game Scanner'
- Extract and run the DriectX Library installer
- Login to Steam
  - Create a Steam Library on the ephemeral disk (Z:\)
  - Install Some Games
- Create a Desktop shortcut which will disconnect your RDP but leave session unlocked for Steam Streaming:
  - `C:\Windows\system32\tscon.exe %sessionname% /dest:console`

Restart the computer after you verify it's good (also on the TODO automation list)


A good resource to use: http://www.win2012workstation.com/
Other Good Resources:
  - http://lg.io/2015/07/05/revised-and-much-faster-run-your-own-highend-cloud-gaming-service-on-ec2.html
  - https://www.reddit.com/r/cloudygamer/
