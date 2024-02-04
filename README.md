# Fedora i3 Configuration Files

As a Fedora user who values a minimal and lightweight operating system, I have chosen the [Fedora i3 spin](https://fedoraproject.org/spins/i3/) as my preferred operating system. 
This spin aligns with my preference for a minimalistic and efficient user experience.

## Customization and Preferences

I have a keen interest in customization, creating my own shortcuts, and configuring blocks that provide essential system information. This includes details about storage, network status, battery status, and facilitates easy window management – all accessible with keyboard shortcuts.

In my workflow, I prioritize keyboard-centric actions and avoid using a mouse whenever possible. Whether it's resizing or moving windows, I prefer to execute these actions with my personalized key bindings.

## Polybar for Bar Customization

For enhancing the appearance and functionality of my desktop, I use [Polybar](https://github.com/polybar/polybar). Polybar allows me to customize the status bar at the top of my screen, providing information at a glance and offering quick access to various functionalities.

## Installation Process

To set up my customized i3 environment, follow these steps:

1. Install the required packages:

   ```bash
   sudo dnf install -y $(cat packages)
   ```
2. Copy `i3` and `polybar` configurations to the `~/.config` directory:
   ```bash
   cp -r i3 ~/.config/
   cp -r polybar ~/.config/
   ```
3. Copy `fonts` to the `~/.local/share/fonts/` directory:
   ```bash
   cp -r fonts ~/.local/share/fonts/
   ```
4. Install additional packages for the `screencast` script:
   ```bash
   sudo dnf copr enable vishalvvr/byzanz
   sudo dnf install byzanz
   pip install python-xrectsel --user
   ```
