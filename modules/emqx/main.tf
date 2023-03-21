locals {
  home       = "/home/azureuser"
  public_ip  = azurerm_linux_virtual_machine.vm.public_ip_address
  private_ip = azurerm_linux_virtual_machine.vm.private_ip_address
}

# Create (and display) an SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.namespace}_vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.vm_size
  network_interface_ids = [var.nic_ids[0]]

  os_disk {
    name                 = "${var.namespace}_disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = "30"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "emqx"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  tags = merge(var.additional_tags, {
    source = "terraform"
  })
}

resource "null_resource" "ssh_connection" {
  depends_on = [azurerm_linux_virtual_machine.vm]

  connection {
    type        = "ssh"
    host        = local.public_ip
    user        = "azureuser"
    private_key = tls_private_key.ssh.private_key_pem
  }

  # create init script
  provisioner "file" {
    content = templatefile("${path.module}/scripts/init.sh", { local_ip = local.private_ip,
      emqx_lic = var.emqx_lic, enable_ssl_two_way = var.enable_ssl_two_way,
    emqx_ca = var.ca, emqx_cert = var.cert, emqx_key = var.key })
    destination = "/tmp/init.sh"
  }

  # download emqx
  provisioner "remote-exec" {
    inline = [
      "curl -L --max-redirs -1 -o /tmp/emqx.zip ${var.emqx_package}"
    ]
  }

  # init system
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
      "sudo mv /tmp/emqx ${local.home}",
    ]
  }

  # Note: validate the above variables, you have to start emqx separately
  provisioner "remote-exec" {
    inline = [
      "sudo ${local.home}/emqx/bin/emqx start"
    ]
  }
}
