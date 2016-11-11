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
