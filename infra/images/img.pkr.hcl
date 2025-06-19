packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1" # Use the latest compatible version (e.g., "~> 1" or a specific version like "1.2.9")
    }
  }
}

variable "region" {
  type    = string
  default = "ap-south-2"
}

// creates a formatted timestamp to keep your AMI name unique.
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "webserver" {
  ami_name      = "node-nginx-webserver-${local.timestamp}"
  source_ami    = "ami-07891c5a242abf4bc" # IMPORTANT: Ensure this AMI exists and is valid in your specified region ("ap-south-2")
  instance_type = "t3.micro"
  region        = var.region
  ssh_username  = "ubuntu"

  tags = {
    Name = "node-nginx-webserver-${local.timestamp}"
  }
}

build {
  sources = ["source.amazon-ebs.webserver"]

  provisioner "shell" {
    script = "./setup.sh"
  }
}
