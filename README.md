# WezTerm Customization

This repository contains my custom configuration for [WezTerm](https://wezfurlong.org/wezterm/), a GPU-accelerated terminal emulator and multiplexer. The configuration focuses on aesthetics, usability, and convenience, offering a smooth and visually appealing terminal experience.

## Features

- **Dynamic Status Bar (Optional)**: Capability to display the current time and battery status in the right corner of the terminal. (Commented out by default)
- **Automatic Theme Switching**: Switches between light and dark themes based on the system appearance.
- **Custom Fonts**: Uses `CaskaydiaCove Nerd Font` with a fallback to `FiraCode Nerd Font` for enhanced readability and icon support.
- **Background Opacity**: Semi-transparent background for a sleek look.
- **Enhanced Tabs and Panes**: Custom tab and pane appearance with clear distinction between active and inactive states.
- **Custom Keybindings**: Efficient navigation and pane management with custom keybindings.
- **Mouse Bindings**: Additional mouse bindings for easier text selection and clipboard operations.
- **Workspace Management**: Simplified management of workspaces and tabs.

## Configuration Details

### Status Bar (Optional)

The configuration includes an optional block of code that, when uncommented, displays the current date, time, and battery status in the right status bar of the terminal window. The left status bar can also be configured to display terminal-specific information.

```lua
-- Uncomment this block if you want to display a status bar with date, time, and battery info.
wezterm.on("update-right-status", function(window, pane)
  local date = wezterm.strftime("%a %-d %b %y %H:%M ")
  local bat = ""

  for _, b in ipairs(wezterm.battery_info()) do
    bat = wezterm.nerdfonts.md_battery .. " " .. string.format("%.0f%%", b.state_of_charge * 100)
  end

  window:set_right_status(wezterm.format({
    { Text = " | " .. wezterm.nerdfonts.fa_clock_o .. " " .. date .. " | " .. bat .. "  | " },
  }))

  window:set_left_status(wezterm.format({
    { Text = " | " .. wezterm.nerdfonts.fa_terminal .. " " .. pane.title .. " | " },
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
  { family = "CaskaydiaCove Nerd Font", scale = 1.4, weight = "Medium" },
  { family = "FiraCode Nerd Font", scale = 1.4 },
})
config.line_height = 1.2
```

### Background Opacity

The terminal background is semi-transparent with an opacity setting of 0.6.

```lua
config.window_background_opacity = 0.6
```

### Tabs and Panes

The configuration disables the tab bar by default, but it includes settings to enhance the appearance of panes, with different colors for active and inactive panes.

```lua
config.enable_tab_bar = false
config.tab_bar_at_bottom = false

config.inactive_pane_hsb = {
  hue = 0.0,
  saturation = 0.25,
  brightness = 0.5,
}
```

### Custom Keybindings

Custom keybindings are defined for quick pane management and navigation. The leader key is set to `Ctrl + a`.

```lua
config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  { key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
  { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  { key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
  { key = "{", mods = "LEADER|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "LEADER|ALT", action = act.MoveTabRelative(1) },
  { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "n", mods = "LEADER", action = act.ShowTabNavigator },
  { key = "e", mods = "LEADER", action = act.PromptInputLine({
    description = wezterm.format({
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { AnsiColor = "Fuchsia" } },
      { Text = "Renaming Tab Title...:" },
    }),
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  })},
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
  { key = "c", mods = "CTRL", action = act.CopyTo("ClipboardAndPrimarySelection") },
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

-- Keybindings for activating specific tabs directly
for i = 1, 9 do
  table.insert(config.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
end
```

### Mouse Bindings

Custom mouse bindings are set up for easier text selection and clipboard operations, such as copying on right-click or selecting text on triple-click.

```lua
mouse_bindings = {
  {
    event = { Down = { streak = 3, button = "Left" } },
    action = act.SelectTextAtMouseCursor("SemanticZone"),
    mods = "NONE",
  },
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act({ PasteForm = "Clipboard" }), pane)
      end
    end),
  },
}
config.mouse_bindings = mouse_bindings
```

## Installation

1. Install [WezTerm](https://wezfurlong.org/wezterm/).
2. Create the WezTerm configuration directory if it doesn't already exist:

```bash
mkdir -p ~/.config/wezterm
```

3. Clone this repository directly into your WezTerm configuration directory:

```bash
git clone https://github.com/mBuergi86/my_wezterm.git ~/.config/wezterm
```

4. Start WezTerm to see the customization in action.

## License

This configuration is licensed under the General Public License v3.0. You are free to use, modify, and distribute this configuration under the terms of this license.

## Acknowledgments

- [WezTerm](https://wezfurlong.org/wezterm/)
- [Catppuccin Theme](https://github.com/catppuccin)
