provider "aws" {
region = "us-east-2"


}

resource "aws_key_pair"  "mykey" {

key_name = "my_public_key"
public_key = file("/root/.ssh/id_rsa.pub")




}


resource "aws_instance" "hadoop_node" {

#instance_type = "m5a.4xlarge"
#instance_type = "c5.large"
instance_type = "t2.micro"
ami = "ami-01e36b7901e884a10"
root_block_device {
      volume_type = "gp2"
      volume_size = 100
    }
count = 1

key_name = "${aws_key_pair.mykey.id}"


ebs_block_device {
   device_name = "/dev/sdb"
    volume_size = 50
    volume_type = "gp2"

    delete_on_termination = true
    }




tags =  {

Name = "hadoop_server.*.count"

}

}


output "IP" {

value = "${aws_instance.hadoop_node.*.public_ip}"


}

resource "aws_instance" "cloudera_agents" {

instance_type = "t2.micro"
ami = "ami-01e36b7901e884a10"
root_block_device {
      volume_type = "gp2"
      volume_size = 50
    }
count = 1

key_name = "${aws_key_pair.mykey.id}"


ebs_block_device {
   device_name = "/dev/sdb"
    volume_size = 50
    volume_type = "gp2"

    delete_on_termination = true
    }

}


output "AGENTIPs" {

value = "${aws_instance.cloudera_agents.*.public_ip}"


}
