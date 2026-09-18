#!/bin/bash
# ==============================================================
# setup_container.bash — BUILD TIME ONLY
# Installs/configures image-level resources.
#
# IMPORTANT:
# - No BumperBot source code is cloned here.
# - No ROS workspace is created here.
# - No colcon build is performed here.
# - GitHub is the source of truth for the workspace.
# - The user's workspace lives in the persistent Docker volume.
# ==============================================================

set -e

echo "===== RosForge container build-time setup ====="

source /opt/ros/jazzy/setup.bash

# ==========================================
# Apt package lists
# ==========================================
apt-get update -q

# ==========================================
# CycloneDDS configuration
# ==========================================
cat <<EOF > /etc/cyclone_config.xml
<?xml version="1.0" encoding="UTF-8" ?>
<CycloneDDS>
  <Domain>
    <General>
      <Interfaces>
        <NetworkInterface name="lo" priority="default" multicast="true"/>
      </Interfaces>
      <AllowMulticast>true</AllowMulticast>
      <MaxMessageSize>65500B</MaxMessageSize>
    </General>
  </Domain>
</CycloneDDS>
EOF

echo "===== Build-time setup complete ====="
