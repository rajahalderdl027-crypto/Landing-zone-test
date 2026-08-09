variable "rgs" {}
variable "vnets" {}
variable "subnets" {}
variable "network_interface" {}
variable "pips" {}
variable "vms" {}


module "rgs" {
  source = "../../Childmodule/azurerm_rg"
  rgs    = var.rgs
}
module "vnets" {
  depends_on = [module.rgs]
  source     = "../../Childmodule/azurerm_vnet"
  vnets      = var.vnets
}
module "subnets" {
  depends_on = [module.vnets]
  source     = "../../Childmodule/azurerm_subnet"
  subnets    = var.subnets
}

module "public_ip" {
  depends_on = [module.rgs]
  source     = "../../Childmodule/azurerm_pip"
  pips       = var.pips
}


module "vms" {
  depends_on        = [module.subnets, module.public_ip]
  source            = "../../Childmodule/azurerm_vm"
  vms               = var.vms
  network_interface = var.network_interface

}