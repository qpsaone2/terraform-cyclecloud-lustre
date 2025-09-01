####################################################
#               Resource Group                     #
####################################################

# 1.리소스 그룹 생성 
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}


####################################################
#               Virtual Network                    #
####################################################

# 1.가상네트워크 모듈 
module "vnet" {
  source             = "./modules/vnet"
  rg_name            = azurerm_resource_group.rg.name
  location           = var.location
  vnet_name          = var.vnet_name
  vnet_address_space = var.vnet_address_space
  tags               = var.tags
  
  # 의존성 주입 (리소스 그룹 생성 후 가상네트워크 생성)
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# 2.Bastion 서브넷 모듈
module "snet_bastion" {
  source         = "./modules/snet"
  rg_name        = azurerm_resource_group.rg.name
  vnet_name      = module.vnet.vnet_name
  subnet_name    = "AzureBastionSubnet"
  address_prefix = var.cidr_bastion
  
  # 의존성 주입 (가상네트워크 생성 후 서브넷 생성)
  depends_on = [
    module.vnet
  ]
}

# 3.Cyclecloud 가상머신 서브넷 모듈 
module "snet_cycle" {
  source         = "./modules/snet"
  rg_name        = azurerm_resource_group.rg.name
  vnet_name      = module.vnet.vnet_name
  subnet_name    = "cyclecloud-vm-snet"
  address_prefix = var.cidr_cycle

  # 의존성 주입 (가상네트워크 생성 후 서브넷 생성) 
  depends_on = [
    module.vnet
  ]
}


# 4.Managed Lustre 서브넷 모듈 
module "snet_lustre" {
  source         = "./modules/snet"
  rg_name        = azurerm_resource_group.rg.name
  vnet_name      = module.vnet.vnet_name
  subnet_name    = "lustre-snet"
  address_prefix = var.cidr_lustre

  # 의존성 주입 (가상네트워크 생성 후 서브넷 생성)
  depends_on = [
    module.vnet
  ]
}



####################################################
#             Network Security Group               #
####################################################

# 1. Bastion Host NSG 모듈 
module "nsg_bastion" {
  source             = "./modules/nsg/bastion"
  rg_name            = azurerm_resource_group.rg.name
  location           = var.location
  nsg_name           = "nsg-bastion"
  allowed_public_ips = var.allowed_public_ips
  tags               = var.tags
  
  # 의존성 주입 (리소스 그룹 생성 후 NSG 생성)
  depends_on = [
    azurerm_resource_group.rg
  ]
}


# 2. Cyclecloud 가상머신 NSG 모듈
module "nsg_cycle" {
  source       = "./modules/nsg/cyclecloud"
  rg_name      = azurerm_resource_group.rg.name
  location     = var.location
  nsg_name     = "nsg-cyclecloud"
  bastion_cidr = var.cidr_bastion
  allowed_public_ips = var.allowed_public_ips
  tags         = var.tags

  # 의존성 주입 (리소스 그룹 생성 후 NSG 생성)
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# 3. Managed Lustre NSG 모듈 (필요 시 활성화)
# module "nsg_lustre" {
#   source   = "./modules/nsg/lustre"
#   rg_name  = azurerm_resource_group.rg.name
#   location = var.location
#   nsg_name = "nsg-lustre"
#   tags     = var.tags
#
#   depends_on = [
#     azurerm_resource_group.rg
#   ]
# }

####################################################
#                NSG associate                     #
####################################################

# 1. Bastion Subnet NSG 할당 모듈
module "assoc_bastion" {
  source    = "./modules/nsg_assoc"
  subnet_id = module.snet_bastion.subnet_id
  nsg_id    = module.nsg_bastion.nsg_id

  # 의존성 주입 (Bastion 서브넷, NSG 생성 후 할당)
  depends_on = [
    module.snet_bastion,
    module.nsg_bastion
  ]
}

# 2. Cyclecloud Subnet NSG 할당 모듈
module "assoc_cycle" {
  source    = "./modules/nsg_assoc"
  subnet_id = module.snet_cycle.subnet_id
  nsg_id    = module.nsg_cycle.nsg_id

  # 의존성 주입 (cyclecloud 서브넷, NSG 생성 후 할당)
  depends_on = [
    module.snet_cycle,
    module.nsg_cycle
  ]
}

# 3. Managed Lustre Subnet NSG 할당 모듈(필요 시 활성화)
# module "assoc_lustre" {
#   source    = "./modules/nsg_assoc"
#   subnet_id = module.snet_lustre.subnet_id
#   nsg_id    = module.nsg_lustre.nsg_id
#
#   depends_on = [
#     module.snet_lustre,
#     module.nsg_lustre
#   ]
# }


####################################################
#                Storage account                   #
####################################################

# 1. Cyclecloud 가상머신 스토리지 계정 모듈
module "stg_cyclecloud" {
  source     = "./modules/storage"
  rg_name    = azurerm_resource_group.rg.name
  location   = var.location
  name       = var.cyclecloud_storage_name
  containers = ["cyclecloud", "logs"]
  tags       = var.tags
 
  # 의존성 주입 (리소스그룹 생성 후 스토리지 계정 생성)
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# 2. 학습용 데이터 스토리지 계정 모듈
module "stg_dataset" {
  source     = "./modules/storage"
  rg_name    = azurerm_resource_group.rg.name
  location   = var.location
  name       = var.dataset_storage_name
  containers = ["datasets", "logs"]
  tags       = var.tags

  # 의존성 주입 (리소스그룹 생성 후 스토리지 계정 생성)
  depends_on = [
    azurerm_resource_group.rg
  ]
}


####################################################
#               Virtual Machines                   #
####################################################

# 1. 가상머신 SSH 키 관리 (로컬)
locals {
  ssh_public_key_content = (
    var.ssh_public_key != "" ?
    var.ssh_public_key :
    file(var.ssh_public_key_path)
  )
}

# 2. Cyclecloud 가상머신 모듈 
module "cyclecloud_vm" {
  source         = "./modules/vm"
  rg_name        = azurerm_resource_group.rg.name
  location       = var.location
  subnet_id      = module.snet_cycle.subnet_id
  vm_name        = "cyclecloud-vm-01"
  vm_size        = var.vm_size
  admin_username = var.admin_username
  ssh_public_key = local.ssh_public_key_content

  cc_img_publisher  = var.cc_img_publisher
  cc_img_offer      = var.cc_img_offer
  cc_img_sku        = var.cc_img_sku
  cc_img_version    = var.cc_img_version

  cc_plan_name      = var.cc_plan_name
  cc_plan_product   = var.cc_plan_product
  cc_plan_publisher = var.cc_plan_publisher
  
  tags           = var.tags

}

# 3. Bastion Host 모듈
module "bastion" {
  source       = "./modules/bastion"
  rg_name      = azurerm_resource_group.rg.name
  location     = var.location
  bastion_name = "bastion-01"
  subnet_id    = module.snet_bastion.subnet_id
  tags         = var.tags
}


####################################################
#                     RBAC                         #
####################################################

# 1. 스토리지 계정 RBAC 모듈 
module "lustre_rbac" {
  source = "./modules/rbac/lustre"
  
  storage_account_id = module.stg_dataset.storage_account_id

  # 의존성 주입 (학습용 데이터 스토리지 계정 생성 후 RBAC 설정)
  depends_on = [
    module.stg_dataset
  ]
}


####################################################
#               Managed Lustre                     #
####################################################

# 1. Managed Lustre 모듈
module "lustre_fs" {
  source = "./modules/lustre"

  lustre_name         = "hpc-lustre-fs"
  sku_name            = "AMLFS-Durable-Premium-500"
  storage_capacity_tb = 4

  rg_name              = azurerm_resource_group.rg.name
  location             = var.location
  subnet_id            = module.snet_lustre.subnet_id
  storage_container_id = module.stg_dataset.container_ids["datasets"] # 연동할 컨테이너 이름 : 'datasets'
  logging_container_id = module.stg_dataset.container_ids["logs"] # 연동할 컨테이너 이름 : 'logs'
  tags                 = var.tags

  # 의존성 주입 (스토리지 계정, RBAC 설정 후 Lustre 생성)
  depends_on = [
    module.stg_dataset,
    module.lustre_rbac
  ]
}
