FROM osrf/ros:jazzy-desktop-full
ARG TARGETPLATFORM
ARG TARGETARCH
ARG QEMU_CPU
LABEL maintainer="Sami Turki - RosForge.com"
SHELL ["/bin/bash", "-c"]

# ==========================================
# Bumperbot (github.com/AntoBrandi/Bumper-Bot, Apache-2.0) is pre-cloned
# and pre-built into this image so the workshop starts with a working
# robot immediately — no network-dependent clone step eating into
# session time. Same VNC/XFCE/noVNC desktop stack as the TB3 and UR5
# teaching images (proven to work reliably).
# ==========================================

ENV ROS_DISTRO=jazzy

# ==========================================
# OpenGL — ENV so it applies to ALL processes (Gazebo + RViz both
# benefit from software rendering when there's no GPU passthrough).
# ==========================================
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV MESA_GL_VERSION_OVERRIDE=3.3
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV CYCLONEDDS_URI=file:///home/ubuntu/cyclone_config.xml

# ==========================================
# Desktop + VNC + noVNC
# (identical stack to the TB3 / UR5 images — proven to work)
# ==========================================
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 xfce4-terminal xfwm4 \
    dbus-x11 \
    x11-utils \
    tigervnc-standalone-server tigervnc-common \
    supervisor wget curl gosu git sudo \
    python3-full python3-pip tini \
    build-essential vim lsb-release locales \
    bash-completion tzdata \
    terminator \
    evince \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ==========================================
# noVNC
# ==========================================
RUN git clone https://github.com/AtsushiSaito/noVNC.git -b add_clipboard_support /usr/lib/novnc && \
    pip install --no-cache-dir --break-system-packages git+https://github.com/novnc/websockify.git@v0.10.0 && \
    ln -s /usr/lib/novnc/vnc.html /usr/lib/novnc/index.html && \
    sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/lib/novnc/app/ui.js

# ==========================================
# Bumperbot's own Dockerfile (verified against the repo) relies almost
# entirely on `rosdep install` to pull Gazebo/Nav2/SLAM/ros2_control
# dependencies from each package's package.xml, plus these two
# explicitly-listed extras:
# ==========================================
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
        libserial-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir --break-system-packages pyserial

# ==========================================
# Build-time setup: clone + rosdep + colcon build Bumperbot
# ==========================================
COPY ./setup_container.bash /
RUN chmod +x /setup_container.bash && bash /setup_container.bash

# ==========================================
# Runtime entrypoint
# ==========================================
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENV USER=ubuntu
ENV PASSWD=ubuntu

HEALTHCHECK --interval=15s --timeout=5s --start-period=20s --retries=3 \
    CMD curl -f http://localhost:80 || exit 1

CMD ["/entrypoint.sh"]
