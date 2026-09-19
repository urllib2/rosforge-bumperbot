FROM osrf/ros:jazzy-desktop-full

ARG TARGETPLATFORM
ARG TARGETARCH
ARG QEMU_CPU

LABEL maintainer="Sami Turki - RosForge.com"

SHELL ["/bin/bash", "-c"]

# ==========================================
# ROS 2 Jazzy development environment
#
# The BumperBot source code is NOT included
# in the image.
#
# Source of truth:
#   GitHub: urllib2/Bumper-Bot
#
# Workspace:
#   /home/ubuntu/ros_ws
#
# The workspace is provided at runtime by a
# persistent Docker named volume.
# ==========================================

ENV ROS_DISTRO=jazzy

# ==========================================
# OpenGL / ROS middleware
# ==========================================

ENV LIBGL_ALWAYS_SOFTWARE=1
ENV MESA_GL_VERSION_OVERRIDE=3.3
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV CYCLONEDDS_URI=file:///home/ubuntu/cyclone_config.xml

# ==========================================
# Desktop + VNC + noVNC
# ==========================================

RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 \
    xfce4-terminal \
    xfwm4 \
    dbus-x11 \
    x11-utils \
    tigervnc-standalone-server \
    tigervnc-common \
    supervisor \
    wget \
    curl \
    gosu \
    git \
    sudo \
    python3-full \
    python3-pip \
    tini \
    build-essential \
    vim \
    lsb-release \
    locales \
    bash-completion \
    tzdata \
    terminator \
    evince \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ==========================================
# noVNC
# ==========================================

RUN git clone \
        https://github.com/AtsushiSaito/noVNC.git \
        -b add_clipboard_support \
        /usr/lib/novnc && \
    pip install --no-cache-dir \
        --break-system-packages \
        git+https://github.com/novnc/websockify.git@v0.10.0 && \
    ln -s /usr/lib/novnc/vnc.html /usr/lib/novnc/index.html && \
    sed -i \
        "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" \
        /usr/lib/novnc/app/ui.js

# ==========================================
# ROS 2 dependencies
#
# ros2_control provides:
#   hardware_interface
#
# ros2_controllers provides the controller
# packages used by the BumperBot stack.
# ==========================================

RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
        ros-${ROS_DISTRO}-ros2-control \
        ros-${ROS_DISTRO}-ros2-controllers \
        ros-${ROS_DISTRO}-navigation2 \
        ros-${ROS_DISTRO}-nav2-bringup \
        ros-${ROS_DISTRO}-twist-mux \
        ros-${ROS_DISTRO}-joy-teleop \
        python3-colcon-argcomplete \
        libserial-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash' >> /etc/bash.bashrc

# Python serial support
RUN pip install --no-cache-dir \
    --break-system-packages \
    pyserial

# ==========================================
# Image-level configuration
#
# IMPORTANT:
# - No BumperBot source clone
# - No colcon build
# - No ROS workspace creation
#
# GitHub is the source of truth.
# The workspace is created at runtime inside
# the persistent Docker volume.
# ==========================================

COPY ./setup_container.bash /

RUN chmod +x /setup_container.bash && \
    bash /setup_container.bash

# ==========================================
# Runtime entrypoint
# ==========================================

COPY ./entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENV USER=ubuntu
ENV PASSWD=ubuntu

HEALTHCHECK \
    --interval=15s \
    --timeout=5s \
    --start-period=20s \
    --retries=3 \
    CMD curl -f http://localhost:80 || exit 1

CMD ["/entrypoint.sh"]
