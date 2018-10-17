#!/usr/bin/env bash

installAnsible () {
  sudo apt-get update
  sudo apt install python-pip -y
  pip install -U ansible==2.7
}


installAnsible