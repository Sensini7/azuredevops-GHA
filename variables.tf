variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "vnet-rg"
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "East US 2"
}

variable "environment" {
  description = "The environment tag for the resources"
  type        = string
  default     = "Production"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "example-vnet"
}

variable "vnet_address_space" {
  description = "The address space of the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_name" {
  description = "The name of the public subnet"
  type        = string
  default     = "public-subnet"
}

variable "public_subnet_prefix" {
  description = "The address prefix of the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_name" {
  description = "The name of the private subnet"
  type        = string
  default     = "private-subnet"
}

variable "private_subnet_prefix" {
  description = "The address prefix of the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_route_table_name" {
  description = "The name of the public route table"
  type        = string
  default     = "public-route-table"
}

variable "public_route_name" {
  description = "The name of the public route"
  type        = string
  default     = "internet-route"
}

variable "private_route_table_name" {
  description = "The name of the private route table"
  type        = string
  default     = "private-route-table"
}

variable "public_nsg_name" {
  description = "The name of the network security group for the public subnet"
  type        = string
  default     = "public-nsg"
}

variable "private_nsg_name" {
  description = "The name of the network security group for the private subnet"
  type        = string
  default     = "private-nsg"
}

variable "nic_name" {
  description = "The name of the network interface"
  type        = string
  default     = "example-nic"
}
