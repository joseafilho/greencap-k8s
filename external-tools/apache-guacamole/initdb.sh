#!/bin/bash

set -e

docker run --rm guacamole/guacamole:1.6.0 /opt/guacamole/bin/initdb.sh --postgresql > /home/vagrant/guacamole/init/initdb.sql
