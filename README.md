# RosForge — Bumperbot Workshop Environment (Teacher)

Development environment for a mixed simulation + practice workshop
using [Bumperbot](https://github.com/AntoBrandi/Bumper-Bot) (Antonio
Brandi, Apache-2.0), a differential-drive mobile robot covering
`ros2_control`, sensor fusion (`robot_localization`), SLAM Toolbox,
and Nav2 — verified live in Gazebo + RViz.

This is the **teacher** repo: it has the `docker/` folder used to
build and publish the image. Students should use the lightweight
`main` branch instead (no Docker build required, pulls the prebuilt
image from Docker Hub) — same split as the TB3 and UR5 images.

Bumperbot's source is pre-cloned and pre-built into this image, so a
fresh workshop session starts with a working robot immediately — no
network-dependent clone eating into session time. On first container
boot, that prebuilt workspace is copied onto the host's bind-mounted
`ros_ws/` folder; from then on it's the student's own copy, and
restarting the container never overwrites their changes.

---

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) — runs the container
- [Visual Studio Code](https://code.visualstudio.com/) — your code editor
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) — connects VS Code to the container

> ⚠️ **Minimum requirements:** 12 GB RAM, 4+ CPU cores, 15 GB free disk
> space. Gazebo simulation is heavier than the TB3/UR5 images — a
> weak machine will struggle here more than with those.

---

## Building & Publishing the Image

```bash
cd rosforge-bumperbot-teacher/docker
docker build -t urllib2/rosforge-bumperbot:latest .
docker push urllib2/rosforge-bumperbot:latest
```

The build clones Bumperbot, runs `rosdep install` (which pulls in
Gazebo, Nav2, SLAM Toolbox, and `ros2_control` automatically from each
package's `package.xml` — verified against Bumperbot's own official
Dockerfile), and runs `colcon build` once, all at image build time.
This makes the build itself slower than TB3/UR5, but means every
student gets a ready-to-run robot with zero wait.

---

## Access the Desktop (Gazebo + RViz)

Open: [http://localhost:6082](http://localhost:6082)

Password: `ubuntu`

> 💡 Port `6082` — TB3 uses `6080`, UR5 uses `6081` — so all three can
> run side by side without a port clash.

---

## Course Commands Reference

### Launch the full simulated robot stack

```bash
ros2 launch bumperbot_bringup simulated_robot.launch.py
```

This brings up Gazebo, `robot_state_publisher`, `ros2_control`, and
the robot spawned in simulation.

### Launch the real robot (if using physical hardware)

```bash
ros2 launch bumperbot_bringup real_robot.launch.py
```

Requires an Arduino connected and running the firmware in
`bumperbot_firmware/firmware/robot_control/robot_control.ino`, loaded
via the Arduino IDE beforehand — not applicable for a
simulation-only workshop.

### Teleoperate the robot

```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard
```

### SLAM (mapping)

```bash
ros2 launch bumperbot_mapping slam.launch.py
```
(check `bumperbot_mapping/launch/` for the exact launch file name —
package-specific launch files can be renamed between commits)

### Navigation (Nav2)

```bash
ros2 launch bumperbot_navigation navigation.launch.py
```
(check `bumperbot_navigation/launch/` for the exact launch file name)

### Package overview

| Package | Purpose |
|---|---|
| `bumperbot_bringup` | Top-level launch files (real + simulated robot) |
| `bumperbot_controller` | `ros2_control` config + hardware interface |
| `bumperbot_description` | URDF + Gazebo simulation model |
| `bumperbot_localization` | Odometry (`robot_localization`) + AMCL global localization |
| `bumperbot_mapping` | SLAM Toolbox config + known-pose mapping example |
| `bumperbot_motion` | Nav2 controller plugins |
| `bumperbot_navigation` | Nav2 configuration + launch files |
| `bumperbot_planning` | Nav2 planner plugins |
| `bumperbot_cpp_examples` / `bumperbot_py_examples` | Starter templates for your own nodes |
| `bumperbot_firmware` / `bumperbot_hardware` | Real-robot Arduino code + 3D-print files (not needed for simulation) |

---

## Where Student Code Lives

Same as TB3/UR5 — everything under `ros_ws/` in the cloned repo is
bind-mounted into the container. Deleting or rebuilding the container
never touches this folder; it's a real folder on the student's host
machine.

---

## Troubleshooting

**Gazebo is very slow / laggy**
Expected on machines without a dedicated GPU and under the stated 12GB
RAM minimum — this is the heaviest of the three RosForge images.

**First container boot takes a while**
The image itself is large (Gazebo + Nav2 + SLAM Toolbox + Bumperbot
pre-built) — first `docker compose up` / VS Code container pull will
take longer than TB3/UR5.

**Desktop is blank at localhost:6082**
Wait 15–20 seconds after the container starts (longer than TB3/UR5,
since more services are starting), then refresh.

---

## Support

Having issues? Contact your mentor on WhatsApp or visit [rosforge.com](https://rosforge.com)
