provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
  }
}

# Create Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = var.environment
  }
}

# Create Public Subnet
resource "azurerm_subnet" "public" {
  name                 = var.public_subnet_name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [var.public_subnet_prefix]
}

# Create Private Subnet
resource "azurerm_subnet" "private" {
  name                 = var.private_subnet_name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [var.private_subnet_prefix]
}

# Create Route Table for Public Subnet
resource "azurerm_route_table" "public_rt" {
  name                = var.public_route_table_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  route {
    name           = var.public_route_name
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  tags = {
    environment = var.environment
  }
}

# Associate Public Subnet with Route Table
resource "azurerm_subnet_route_table_association" "public_subnet_rt_association" {
  subnet_id      = azurerm_subnet.public.id
  route_table_id = azurerm_route_table.public_rt.id
}

# Create Route Table for Private Subnet
resource "azurerm_route_table" "private_rt" {
  name                = var.private_route_table_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = var.environment
  }
}

# Associate Private Subnet with Route Table
resource "azurerm_subnet_route_table_association" "private_subnet_rt_association" {
  subnet_id      = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.private_rt.id
}

# Create Network Security Group for Public Subnet
resource "azurerm_network_security_group" "public_nsg" {
  name                = var.public_nsg_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow_inbound_http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_inbound_https"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_outbound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

# Associate Public Subnet with NSG
resource "azurerm_subnet_network_security_group_association" "public_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}

# Create Network Security Group for Private Subnet
resource "azurerm_network_security_group" "private_nsg" {
  name                = var.private_nsg_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow_internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "10.0.0.0/16"
  }

  security_rule {
    name                       = "allow_outbound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

# Associate Private Subnet with NSG
resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

# Create Network Interface with dynamic IP allocation
resource "azurerm_network_interface" "example" {
  name                = var.nic_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public.id # Change to azurerm_subnet.private.id for private subnet
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.environment
  }
}
