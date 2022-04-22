
  # provisioner "remote-exec" {
  #   inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

  #   connection {
  #     host        = self.public_ip
  #     type        = "ssh"
  #     user        = "admin"
  #     private_key = file("id_rsa")
  #   }
  # }

  # provisioner "local-exec" {
  #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u admin -i '${self.public_ip},' --private-key id_rsa ../provision/playbook.yaml"
  # }