####################################################
#             Project Defaults                     #
####################################################

# 1. 리소스 그룹 이름
variable "rg_name" {
  description = "프로젝트의 모든 리소스를 담을 리소스 그룹의 이름"
  type        = string
  default     = "rg-hpc-lab"
}

# 2. 리소스 배포 지역
variable "location" {
  description = "모든 리소스가 배포될 Azure 지역"
  type        = string
  default     = "koreacentral"
}

# 3. 공통 태그
variable "tags" {
  description = "모든 리소스에 공통적으로 적용될 태그"
  type        = map(string)
  default = {
    env   = "lab"
    owner = "hpc"
  }
}


####################################################
#             Virtual Network                      #
####################################################

# 1. 가상 네트워크 (VNet)
variable "vnet_name" {
  description = "생성할 가상 네트워크의 이름"
  type        = string
  default     = "vnet-01"
}

variable "vnet_address_space" {
  description = "가상 네트워크의 전체 IP 주소 공간"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# 2. 서브넷 주소 공간 (Subnet CIDRs)
variable "cidr_bastion" {
  description = "Bastion용 서브넷의 CIDR 블록"
  type        = string
  default     = "10.0.0.0/27"
}

variable "cidr_cycle" {
  description = "CycleCloud VM용 서브넷의 CIDR 블록"
  type        = string
  default     = "10.0.1.0/24"
}

variable "cidr_lustre" {
  description = "Managed Lustre용 서브넷의 CIDR 블록"
  type        = string
  default     = "10.0.2.0/24"
}


####################################################
#             Network Security Group               #
####################################################

# 1. 외부 접속 허용 IP 목록
variable "allowed_public_ips" {
  description = "NSG에서 인바운드를 허용할 공인 IP 주소 목록 (CIDR 형식)"
  type        = list(string)
  default     = []
}


####################################################
#             Storage account                      #
####################################################

# 1. CycleCloud용 스토리지 계정 이름
variable "cyclecloud_storage_name" {
  description = "CycleCloud 데이터를 저장할 스토리지 계정의 이름"
  type        = string
  default     = "cyclecloudstg001"
}

# 2. 데이터셋 및 Lustre 로그용 스토리지 계정 이름
variable "dataset_storage_name" {
  description = "Lustre와 연동될 데이터셋을 저장할 스토리지 계정의 이름"
  type        = string
  default     = "datasetstg001"
}


####################################################
#             Virtual Machines                     #
####################################################

# 1. VM 공통 설정
variable "vm_size" {
  description = "CycleCloud VM의 크기 (SKU)"
  type        = string
  default     = "Standard_D4s_v5"
}

variable "admin_username" {
  description = "VM에 생성될 관리자 계정 이름"
  type        = string
  default     = "azureuser"
}

# 2. VM 접속용 SSH 키
variable "ssh_public_key_path" {
  description = "VM에 등록할 SSH 공개키 파일의 로컬 경로"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_public_key" {
  description = "SSH 공개키 내용을 직접 입력할 때 사용 (경로보다 우선)"
  type        = string
  default     = ""
}


####################################################
#             CycleCloud Marketplace               #
####################################################

# 1. CycleCloud 이미지 설정
variable "cc_img_publisher" {
  description = "CycleCloud 이미지의 게시자"
  type        = string
  default     = "azurecyclecloud"
}

variable "cc_img_offer" {
  description = "CycleCloud 이미지의 제품(Offer)"
  type        = string
  default     = "azure-cyclecloud"
}

variable "cc_img_sku" {
  description = "CycleCloud 이미지의 SKU"
  type        = string
  default     = "cyclecloud8"
}

variable "cc_img_version" {
  description = "CycleCloud 이미지의 버전"
  type        = string
  default     = "latest"
}

# 2. CycleCloud 플랜 설정 (이미지와 동일해야 함)
variable "cc_plan_name" {
  description = "CycleCloud 플랜 이름 (SKU와 동일)"
  type        = string
  default     = "cyclecloud8"
}

variable "cc_plan_product" {
  description = "CycleCloud 플랜 제품 (Offer와 동일)"
  type        = string
  default     = "azure-cyclecloud"
}

variable "cc_plan_publisher" {
  description = "CycleCloud 플랜 게시자 (Publisher와 동일)"
  type        = string
  default     = "azurecyclecloud"
}