terraform {
required_providers {
aws = {
source  = "hashicorp/aws"
version = "~> 3.0"
}
}
}

# Configure the AWS Provider

provider "aws" {
region = "us-east-1"
access_key="ASIAVFPQX52O3U3OWNXL"
secret_key="EhsSCttX+EnCBQnn2vXgltupkpubHPamODiZ2n7f"
token="FwoGZXIvYXdzEOP//////////wEaDEw2Zz8e7rwxvGT61iKvAbmwnkYaDW5sBX1IjSqCMGoOuGkW5SQrqpw84rGh65x8TXAoNkoyl6climlhXVg4ht7VxixLcqRgJyv8A6dp6LNKc/a+ghJX3+9BBQVkoJ92rmWiRlWrMEzcUEVzPByXahI6YOw0/gEqwtPVrlfaBbfOU7aCUsCK3LKHjd2ibz3Q/FcV+d83Vu/wbtfm73zZVokZJqG48VeJCwrLrs95VJrqa7HFkUvkBPOOM5vms5wo3L3xrgYyLakllRlznTAskwCvzJoKuhi2VmMblEUBhIoSqtNXbOvm6PVKdjyX6qKhbEBuug=="
}