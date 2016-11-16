/****************************************************
Pass-in configuration variables to AMI bootstrapping
*****************************************************/

# This doesn't seem to converge without being a template file
# https://support.hashicorp.com/hc/en-us/requests/1580
data "template_file" "user_data" {
  template = "${file("user_data.tpl")}"

}
