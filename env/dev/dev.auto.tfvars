
location = "centralus"

address_space = [
  "10.0.0.0/16",
  "10.1.0.0/16",
  "10.2.0.0/16",
  "10.3.0.0/16",
  "10.4.0.0/16",
  "10.5.0.0/16",
]

subnet_prefixes = {
  "hub-subnet"   = "10.0.0.0/24"
  "spoke-subnet" = "10.1.0.0/24"
  "aks-subnet"      = "10.1.1.0/24"
  "app-gtw-subnet"      = "10.1.2.0/24"
  "AzureBastionSubnet"      = "10.0.1.0/24"
  "subnet6"      = "10.1.4.0/24"
}