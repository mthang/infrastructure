# application server / web server
resource "openstack_compute_instance_v2" "pulsar-nci-test" {
  name            = "pulsar-nci-test"
  image_id        = "b6f837e1-49fe-495d-905a-f4ddb2f6b669" # Ubuntu Jammy Cloud Image 2023-02-15
  flavor_name     = "c3.8c16m10d"
  key_pair        = "galaxy-australia"
  security_groups = ["ssh", "default"]
  availability_zone = "CloudV3"
  network {
    name = "aa63"
  }
}

# worker nodes
resource "openstack_compute_instance_v2" "pulsar-nci-test-w1" {
  name            = "pulsar-nci-test-w1"
  image_id        = "b6f837e1-49fe-495d-905a-f4ddb2f6b669" # Ubuntu Jammy Cloud Image 2023-02-15
  flavor_name     = "c3pl.16c48m60d"
  key_pair        = "galaxy-australia"
  security_groups = ["ssh", "default"]
  availability_zone = "CloudV3"
  network {
    name = "aa63"
  }
}

resource "openstack_compute_instance_v2" "pulsar-nci-test-w2" {
  name            = "pulsar-nci-test-w2"
  image_id        = "b6f837e1-49fe-495d-905a-f4ddb2f6b669" # Ubuntu Jammy Cloud Image 2023-02-15
  flavor_name     = "c3pl.16c48m60d"
  key_pair        = "galaxy-australia"
  security_groups = ["ssh", "default"]
  availability_zone = "CloudV3"
  network {
    name = "aa63"
  }
}

# Volume for application/web server
resource "openstack_blockstorage_volume_v2" "pulsar-nci-test-volume" {
  availability_zone = "CloudV3"
  name        = "pulsar-nci-test-volume"
  description = "Pulsar NCI Test Volume"
  size        = 6000
}

# Attachment between application/web server and volume
resource "openstack_compute_volume_attach_v2" "attach-pulsar-nci-test-volume-to-pulsar-nci-test" {
  instance_id = "${openstack_compute_instance_v2.pulsar-nci-test.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.pulsar-nci-test-volume.id}"
}

#floating ips for project
resource "openstack_networking_floatingip_v2" "floatip_head" {
  pool = "external"
}

#Associate FIPs with instances
resource "openstack_compute_floatingip_associate_v2" "fip_head" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_head.address}"
  instance_id = "${openstack_compute_instance_v2.pulsar-nci-test.id}"
}
