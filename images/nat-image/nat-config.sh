#! /bin/bash

masquerade_packets() {
  echo "Setting up packet masquerading"
  sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE
}
enable_IP_forwarding() {
  echo "Enabling Packet Forwarding"
  echo "net.ipv4.ip_forward=1" | sudo tee --append /etc/sysctl.conf
}
main() {
  masquerade_packets
  enable_IP_forwarding
}
main
