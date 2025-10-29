#!/bin/bash

until [[-f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

apt-get update
apt-get install -y nginx

service nginx start