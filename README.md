# WezTerm Customization

This repository contains my custom configuration for [WezTerm](https://wezfurlong.org/wezterm/), a GPU-accelerated terminal emulator and multiplexer. The configuration focuses on aesthetics, usability, and convenience, offering a smooth and visually appealing terminal experience.

## Features

- **Dynamic Status Bar**: Displays the current time and battery status in the right corner of the terminal.
- **Automatic Theme Switching**: Switches between light and dark themes based on the system appearance.
- **Custom Fonts**: Uses `CaskaydiaCove Nerd Font` with a fallback to `FiraCode Nerd Font` for enhanced readability and icon support.
- **Background Opacity**: Semi-transparent background for a sleek look.
- **Enhanced Tabs**: Custom tab appearance with clear distinction between active and inactive tabs.
- **Custom Keybindings**: Efficient navigation and pane management with custom keybindings.

## Configuration Details

### Status Bar

The right status bar displays the current date, time, and battery status. The battery icon and percentage are shown when the device is on battery power.

```lua
wezterm.on("update-right-status", function(window, pane)
  local date = wezterm.strftime("%a %-d %b %y %H:%M ")
  local bat = ""

  for _, b in ipairs(wezterm.battery_info()) do
    bat = wezterm.nerdfonts.md_battery .. " " .. string.format("%.0f%%", b.state_of_charge * 100)
  end

  window:set_right_status(wezterm.format({
    { Text = " | " .. wezterm.nerdfonts.fa_clock_o .. " " .. date .. " | " .. bat .. "  | " },
  }))
end)
```

### Theme Switching

The color scheme automatically adjusts to match the system's appearance. It uses the "Catppuccin Mocha" theme for dark mode and "Catppuccin Latte" for light mode.

```lua
local function get_appearance()
  if gui then
    return gui.get_appearance()
  end
  return "Dark"
end

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())
```

### Fonts

The configuration uses `CaskaydiaCove Nerd Font` as the primary font, with `FiraCode Nerd Font` as a fallback. The line height is set to 1.2 for improved readability.

```lua
config.font = wezterm.font_with_fallback({
  { family = "CaskaydiaCove Nerd Font", scale = 1.4 },
  { family = "FiraCode Nerd Font", scale = 1.4 },
})
config.line_height = 1.2
```

### Background Opacity

The terminal background is semi-transparent with an opacity setting of 0.8.

```lua
config.window_background_opacity = 0.8
```

### Custom Tab Bar

The tabs are customized to have a distinct appearance for active and inactive tabs, using colors that blend well with the chosen themes.

```lua
config.colors = {
  tab_bar = {
    background = "#2E3440",
    active_tab = {
      bg_color = "#4C566A",
      fg_color = "#ECEFF4",
    },
    inactive_tab = {
      bg_color = "#2E3440",
      fg_color = "#4C566A",
    },
  },
}
```

### Keybindings

Custom keybindings are defined for quick pane management and navigation. The leader key is set to `Ctrl + a`.

```lua
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  { key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
  { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
}
```

## Installation

1. Install [WezTerm](https://wezfurlong.org/wezterm/).
2. Clone this repository or copy the configuration file to your local setup.
3. Replace the contents of your `~/.wezterm.lua` file with the provided configuration.

```bash
git clone https://github.com/yourusername/wezterm-config.git
cp wezterm-config/wezterm.lua ~/.wezterm.lua
```

4. Start WezTerm to see the customization in action.

## License

This configuration is licensed under the MIT License. Feel free to use and modify it as you see fit.

## Acknowledgments

- [WezTerm](https://wezfurlong.org/wezterm/)
- [Catppuccin Theme](https://github.com/catppuccin)

```

You can customize the "Installation" section with your repository's actual URL. This `README.md` should give a comprehensive overview of your WezTerm customization and make it easier for others to use your setup.
```
