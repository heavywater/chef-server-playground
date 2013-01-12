#!/usr/bin/env bash

if [ $(grep -q chef-server-berkshelf /etc/hosts) ]; then
    echo "Chef Server Berkshelf already configured"
else
    echo "33.33.33.10 chef-server-berkshelf" >> /etc/hosts
fi
