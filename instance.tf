resource "vsphere_virtual_machine" "TEST-VM" {
  count = "${var.vmcount}"
  name   = "${var.vmname}_0${count.index + 1}"
  hostname = "${var.vmname}${count.index + 1}"
  vcpu   = 2
  memory = 4096
  domain = "${var.vmdomain}"
  dns_suffixes = [ "${var.vmdomain}" ]
  datacenter = "YOUR_DC"
  cluster = "${lookup(var.vmcluster,var.vmrp)}"
  resource_pool = "${lookup(var.vmcluster, var.vmrp)}/Resources/${var.vmrp}"
  dns_servers = ["${lookup(var.vmdns1,var.vmdomain)}", "${lookup(var.vmdns2,var.vmdomain)}"]

  network_interface {
    label = "${lookup(var.vmnetlabel, var.vmdomain)}"
    ipv4_address = "${lookup(var.vmaddrbase,var.vmdomain)}${10 + count.index}"
    ipv4_gateway = "${lookup(var.vmgateway,var.vmdomain)}"
    ipv4_prefix_length = "24"
  }

  disk {
    template = "Linux_templates/${var.vmtemp}"
    type = "thin"
    datastore = "${lookup(var.vmdscluster, var.vmdatastore)}/${var.vmdatastore}"
  }
}
