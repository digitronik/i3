# My Minimalist i3 & Polybar Desktop on Fedora

This repository contains the complete configuration for my minimalist, keyboard-driven i3wm desktop environment running on the Fedora i3 Spin. It features a clean and functional Polybar status bar, custom menus for easy access to settings and power options, and several scripts to enhance usability.

![screenshot-placeholder](docs/bar.png)


## 1. Installation on Fedora

This guide assumes you are starting with a fresh Fedora install.

### Step 1 — Clone the Repository

```bash
git clone https://github.com/digitronik/i3.git ~/Softwares/i3
cd ~/Softwares/i3
```

### Step 2 — Run the Install Script

A single script handles everything: packages, custom repos, fonts, and build tools. It skips anything already installed and reports any failures clearly at the end.

```bash
bash install.sh
```

### Step 3 — Deploy the Config

Backup existing configs and copy the new ones:

```bash
mv ~/.config/i3 ~/.config/i3.bak 2>/dev/null || true
mv ~/.config/polybar ~/.config/polybar.bak 2>/dev/null || true

cp -r ./i3 ~/.config/
cp -r ./polybar ~/.config/

chmod +x ~/.config/i3/*.sh
chmod +x ~/.config/polybar/*.sh
```

> **Wallpaper:** Place your wallpaper images in `~/.config/i3/pictures/`. A random image is picked on every i3 reload.

### Step 4 — Reload i3

Press `$mod+Shift+c` to reload in-place, or log out and back in for a full restart.

---

## 2. Usage & Keybindings

The modifier key is the **Super** key (Windows key), referred to as `$mod`.

| Keybinding | Action |
| :--- | :--- |
| **System Control** | |
| `$mod+Shift+c` | Reload the i3 configuration file. |
| `$mod+Shift+e` | Show a confirmation prompt to log out of i3. |
| `$mod+l` | Lock the screen. |
| `$mod+Shift+h` | Hibernate (locks screen first). |
| `$mod+Shift+r` | Reboot. |
| `$mod+Shift+s` | Shutdown. |
| **Application Launchers** | |
| `$mod+d` | Launch `dmenu` to run an application. |
| `$mod+Return` or `$mod+t` | Open a new terminal (`tilix`). |
| `$mod+h` | Open the file manager (`thunar`). |
| **Window Management** | |
| `$mod+Shift+q` | Kill the focused window. |
| `$mod` + Arrow Keys | Change window focus. |
| `$mod+Shift` + Arrow Keys | Move the focused window. |
| `$mod+o` / `$mod+v` | Split horizontally / vertically. |
| `$mod+f` | Toggle fullscreen for the focused window. |
| `$mod+s` / `$mod+w` / `$mod+e` | Change layout (stacking / tabbed / toggle split). |
| `$mod+Shift+space` | Toggle floating for the focused window. |
| `$mod+r` | Enter resize mode (use arrow keys to resize). |
| **Scratchpad** | |
| `$mod+Shift+minus` | Move the focused window to the scratchpad. |
| `$mod+minus` | Show/hide the scratchpad window. |
| **Workspaces** | |
| `$mod` + `1-0` | Switch to the corresponding workspace (1–10). |
| `$mod+Shift` + `1-0` | Move the focused window to that workspace. |
| **Hardware & Utilities** | |
| `PrintScreen` | Open `xfce4-screenshooter` for a screenshot. |
| `$mod+PrintScreen` | Start/Stop recording a screen region as a GIF. |
| `$mod+m` | Open display settings (`arandr`). |
| `$mod+Shift+v` | Open advanced audio controls (`pavucontrol`). |
| `Volume Up / Down` | Increase / decrease system volume by 5%. |
| `Mute` | Toggle system audio mute. |
| `Mic Mute` | Toggle microphone mute. |
| `Brightness Up / Down` | Increase / decrease screen brightness. |

---

## 3. Scripts Overview

| Script | Description |
| :--- | :--- |
| `i3/lock.sh` | Central handler for all power and session actions (lock, logout, suspend, hibernate, reboot, shutdown). Called by both the Polybar power menu and i3 keybindings. |
| `i3/battery_notify.sh` | Runs in the background to send desktop notifications when battery is low (≤20%) or fully charged (≥98%). Uses a PID file to ensure only one instance runs at a time. |
| `i3/screencast.sh` | Records a selected screen region as a GIF using `byzanz` and `xrectsel`. Toggle start/stop with `$mod+PrintScreen`. Tracks the recorder PID so stopping is precise. |
| `polybar/launch.sh` | Kills any running Polybar/i3bar instances and starts Polybar fresh. Called on every i3 reload via `exec_always`. |
| `polybar/bluetooth.sh` | Displays Bluetooth status (on/off/connected device) in Polybar. Left-click toggles power; right-click opens `blueman-manager`. |
| `polybar/check-vpn.sh` | Checks for an active VPN connection (via `tun0`) and shows green "VPN Active" or red "VPN Down" in Polybar. |
| `polybar/powermenu.sh` | Displays a `zenity` pop-up power menu. Accessible via the power icon in Polybar. |
| `polybar/settings.sh` | Displays a `zenity` pop-up settings menu with quick access to audio, display, network, and config files. |

---
