# Assignment 1


Design an automation deployed with GITHUB/GITLAB pipelines to create load balanced simple nginx hosted on 1 or more virtual machines on AWS or Azure with the following assumption :

CIDR retrieve from REST API https://FDQN/vend_ip return<br/>
{<br/>
   "ip_address":"192.168.0.0",<br/>
   "subnet_size":"/16"<br/>
}<br/>
Create subnets with size /24<br/>
Generate SSH key for VM credential<br/>
Take into consideration CSP Best Practices such as security and resiliency<br/>
Take into consideration coding/scripting practices<br/>
Can use bash/terraform/python/powershell for the stack, github or github for the IAC pipeline
