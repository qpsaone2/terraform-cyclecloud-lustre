# 1.Public IP 주소 생성 (CycleCloud 접속용)
resource "azurerm_public_ip" "pip" {
  name                = "${var.vm_name}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# 2.네트워크 인터페이스 (NIC) 생성
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id # Public IP 연결
  }

  tags = var.tags
}

# 3.azurerm_virtual_machine 리소스 생성 
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size

  # OS 디스크 설정
  storage_os_disk {
    name          = "${var.vm_name}-OsDisk"
    caching       = "ReadWrite"
    create_option = "FromImage" # '이미지로부터 생성' 옵션이 핵심
  }

  # Market Place이미지 정보
  storage_image_reference {
    publisher = var.cc_img_publisher
    offer     = var.cc_img_offer
    sku       = var.cc_img_sku
    version   = "latest"
  }
  # Market Place 플랜 정보 (이미지 사용 약관 동의)
  plan {
    name      = var.cc_plan_name
    product   = var.cc_plan_product
    publisher = var.cc_plan_publisher
  }
  
  # 게스트 OS 프로필 설정 (컴퓨터 이름, 관리자 계정)
  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
  }

  # Linux 게스트 OS 세부 설정 (SSH 키)
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }

  # VM 관리 ID(Managed Identity) 설정
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

output "vm_id" { value = azurerm_virtual_machine.vm.id }
output "private_ip" { value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address }
output "nic_id" { value = azurerm_network_interface.nic.id }
