#!/bin/bash
# ==============================================================
# setup_container.bash  —  BUILD TIME ONLY
# Runs once during `docker build`. Must not touch users, home
# directories, or .bashrc — those are runtime concerns handled
# by entrypoint.sh.
# ==============================================================
set -e
echo "===== Bumperbot workspace build-time setup ====="
source /opt/ros/jazzy/setup.bash

# ==========================================
# Ensure apt package lists are present.
# Previous Dockerfile layers often clean /var/lib/apt/lists/*
# which causes "Unable to locate package" for every ros-jazzy-*
# (and even python3-serial / python3-smbus).
# ==========================================
apt-get update -q

# ==========================================
# CycloneDDS config
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

# ==========================================
# Clone Bumperbot (Apache-2.0) into a build-time location.
# Not /home/ubuntu yet — that directory may not exist until
# entrypoint.sh creates the user at runtime. entrypoint.sh copies
# this into place on first boot, same pattern as cyclone_config.xml.
# ==========================================
mkdir -p /opt/bumperbot_ws/src
cd /opt/bumperbot_ws/src
git clone https://github.com/AntoBrandi/Bumper-Bot.git

# ==========================================
# rosdep — pulls in Gazebo, Nav2, SLAM Toolbox, ros2_control, etc.
# automatically from each package's package.xml (verified against
# Bumperbot's own Dockerfile — this is their exact approach too)
# ==========================================
rosdep init 2>/dev/null || true
rosdep update
cd /opt/bumperbot_ws
rosdep install --from-paths src --ignore-src -r -y --rosdistro jazzy

# ==========================================
# Build once at image build time — students get a working robot
# immediately, no build wait at workshop start.
# ==========================================
colcon build --symlink-install
echo "===== Build-time setup complete ====="
