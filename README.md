# dotfiles-awesome

![image](https://user-images.githubusercontent.com/1719781/135058892-5b339356-6254-4d0b-b27e-2de60a0ce49b.png)

Configuration for the Awesome window manager

# Testing changes

To run awesome inside Xephyr for testing use the provided `flake.nix`. 

```
nix run
```

#### rc.lua

Entry point for the configuration. Mainly used to declare some global variables
and to tie everything else together.

#### theme.lua

Appearance options and colors. Most configuration options are read with `xrdb`
from `~/.Xresources` to match the settings of other applications and keep those
in a central place. It will use my
[wallpaper-generator](https://github.com/pinpox/wallpaper-generator) to generate
a wallpaper for each screen, matching the colors of the theme.

#### wallpaper.lua

Helper funcions and hooks to generate wallpaper on screen changes, e.g. when a
monitor is pluggend in.

#### tags.lua

Set up tags (worspaces) using
[awesome-sharedtags](https://github.com/Drauthius/awesome-sharedtags). The
behaviour is similar to the workspaces in i3, i.e. tags/workspaces are created
when switched to them on the current screen and destroyed when left empty.

#### mainmenu.lua

Right-click menu

#### keybinds.lua

Defines keybindings and adds them to the help popup with documentation

#### clientrules.lua

Rules to apply to new clients (windows). This includes adding the title bars,
keybinds and also some application-specific settings like defaulting to floating
layout for applications that require it.

#### errors.lua

Error handling. Shows configuration errors if they occur during startup or
runtime.

#### bar.lua

The main, incuding a window list, tag list and tray.

#### clientsignals.lua

Signals called on specific actions, e.g. when focusing a window.

