#!/bin/bash
# Script to configure hosts file

set -e

echo "=========================================="
echo "Cleaning hosts file"
echo "=========================================="

# Remove existing entries between [begin:greencap] and [end:greencap]
if grep -q "\[begin:greencap\]" /etc/hosts && grep -q "\[end:greencap\]" /etc/hosts; then
    echo "Removing existing entries between [begin:greencap] and [end:greencap] in /etc/hosts..."
    sudo sed -i '/\[begin:greencap\]/,/\[end:greencap\]/d' /etc/hosts
fi

echo "Hosts file cleaned successfully."
echo "=========================================="