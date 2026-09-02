# RosForge — Bumperbot Workshop Environment

Your local development environment for the RosForge Bumperbot
workshop — a differential-drive mobile robot built on
[Bumperbot](https://github.com/AntoBrandi/Bumper-Bot) (Antonio Brandi,
Apache-2.0), covering `ros2_control`, sensor fusion, SLAM, and Nav2 in
Gazebo simulation.

---

## Prerequisites

Install these tools **before the workshop**:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) — runs the container
- [Visual Studio Code](https://code.visualstudio.com/) — your code editor
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) — connects VS Code to the container

> ⚠️ **Minimum requirements:** 12 GB RAM, 4+ CPU cores, 15 GB free disk space.
> Gazebo simulation is heavier than a typical ROS2 exercise — please
> confirm your machine meets this before the session.

> 💡 **Windows users:** Docker Desktop installs and manages WSL2 automatically.

---

## ⚠️ Do This Before the Workshop

The container image is several GB. Pulling it live during the session
for a full room of students will eat into workshop time. Please do
**Steps 1–2 below at home**, on a good connection, before the
session.

---

## First-Time Setup

### Step 1 — Clone the workshop repository

```bash
git clone https://github.com/urllib2/rosforge-bumperbot.git
```

### Step 2 — Open in VS Code and let it pull the image

1. Open VS Code
2. **File → Open Folder** → select the `rosforge-bumperbot/` folder
3. Click **"Reopen in Container"** when prompted (or **Ctrl+Shift+P** → `Dev Containers: Reopen in Container`)
4. This pulls the image from Docker Hub — several GB, can take a
   while depending on your connection. This is the step to do ahead
   of time.

### Step 3 — Set up Continue.dev (AI assistant)

1. Copy the template config:
   - Windows: copy `continue_config.template.yaml` to `continue_config\config.yaml`
   - Mac/Linux: `cp continue_config.template.yaml continue_config/config.yaml`
2. Open `continue_config/config.yaml` and replace the placeholder API
   keys with your own (OpenRouter / DeepSeek)
3. Save — Continue.dev picks it up automatically inside the container

### Step 4 — Confirm the workspace is ready

Bumperbot is already cloned and built into your `ros_ws/` on first
container boot — you shouldn't need to build anything yourself. Open
a terminal in VS Code and check:

```bash
ls ~/ros_ws/src
```

You should see the Bumperbot packages already there (`bumperbot_bringup`,
`bumperbot_description`, etc.). If `ros2` commands aren't found,
source the workspace manually:

```bash
source /opt/ros/jazzy/setup.bash
source ~/ros_ws/install/setup.bash
```

---

## Daily Usage

Every time you open VS Code:

1. **Ctrl+Shift+P** → `Dev Containers: Reopen in Container`
2. Your workspace is ready — the image is already pulled, no wait

---

## Access the Desktop (Gazebo + RViz)

Open: [http://localhost:6082](http://localhost:6082)

Password: `ubuntu`

> 💡 If the desktop is blank, wait 15–20 seconds after the container starts and refresh.

---

## Where to Write Your Code

```
rosforge-bumperbot/
└── ros_ws/
    └── src/         ← Bumperbot packages + any new packages you add
```

This folder is synchronized between your machine and the container.
Your code is always saved on your machine — even if the container is
deleted or rebuilt.

---

## Workshop Commands Reference

### Launch the full simulated robot

```bash
ros2 launch bumperbot_bringup simulated_robot.launch.py
```

### Teleoperate the robot with your keyboard

```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard
```

### SLAM (build a map)

```bash
ros2 launch bumperbot_mapping slam.launch.py
```

### Navigation (Nav2)

```bash
ros2 launch bumperbot_navigation navigation.launch.py
```

> 💡 If any launch file name above isn't found, check the actual
> filename with: `ls ~/ros_ws/src/Bumper-Bot/<package_name>/launch/`

---

## Package Overview

| Package | Purpose |
|---|---|
| `bumperbot_bringup` | Top-level launch files |
| `bumperbot_controller` | `ros2_control` configuration |
| `bumperbot_description` | URDF + Gazebo simulation model |
| `bumperbot_localization` | Odometry + AMCL localization |
| `bumperbot_mapping` | SLAM Toolbox |
| `bumperbot_navigation` / `bumperbot_motion` / `bumperbot_planning` | Nav2 configuration and plugins |
| `bumperbot_cpp_examples` / `bumperbot_py_examples` | Starter templates for your own nodes |

---

## Troubleshooting

**Container not starting**
Make sure Docker Desktop is running before opening VS Code.

**Gazebo is very slow / laggy**
Expected on machines below the 12GB RAM minimum, or without a
dedicated GPU — the container uses software rendering.

**Desktop is blank at localhost:6082**
Wait 15–20 seconds after the container starts, then refresh.

**`ros2` command not found in a new terminal**
Run `source /opt/ros/jazzy/setup.bash && source ~/ros_ws/install/setup.bash`

**VS Code says "container already exists"**
Open Docker Desktop, stop and remove the `rosforge-bumperbot` container, then reopen in VS Code.

**Continue.dev API key lost after reinstall**
Your key is stored in `rosforge-bumperbot/continue_config/` on your
machine. Keep this folder safe.

---

## Support

Having issues? Contact your mentor on WhatsApp or visit [rosforge.com](https://rosforge.com)
