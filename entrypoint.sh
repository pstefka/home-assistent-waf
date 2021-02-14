#!/bin/bash

apt-get update
apt-get install -y geoip-database libgeoip1

nginx -g 'daemon off;'
