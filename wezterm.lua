local wezterm = require("wezterm")
local gui = wezterm.gui
local act = wezterm.action
local font = wezterm.font

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

local config = {}

-- Use the `wezterm` module to provide config
if wezterm.config_builder then
	config = wezterm.config_builder()
end

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

-- Settings
config.line_height = 1.2
config.font = wezterm.font_with_fallback({
	{ family = "CaskaydiaCove Nerd Font", scale = 1.4 },
	{ family = "FiraCode Nerd Font", scale = 1.4 },
})
config.color_scheme = scheme_for_appearance(get_appearance())
--config.window_background_image = "/path/to/wallpaper.png"
--config.window_background_image_hsb = {
--	hue = 1.0,
--	saturation = 1.0,
--	brightness = 0.3,
--}
config.window_background_opacity = 0.8
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3500
config.default_workspace = "home"
config.window_frame = {
	font = font({ family = "CaskaydiaCove Nerd Font", weight = "Bold" }),
	font_size = 14.0,
	active_titlebar_bg = "#2E3440",
	inactive_titlebar_bg = "#2E3440",
}

-- Settings for tabs
config.colors = {
	tab_bar = {
		background = "#2E3440",
		active_tab = {
			bg_color = "#4C566A",
			fg_color = "#ECEFF4",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#2E3440",
			fg_color = "#4C566A",
			intensity = "Half",
			underline = "None",
			italic = true,
		},
		new_tab = {
			bg_color = "#2E3440",
			fg_color = "#88C0D0",
			intensity = "Normal",
			underline = "None",
			italic = false,
		},
		new_tab_hover = {
			bg_color = "#2E3440",
			fg_color = "#D8DEE9",
			intensity = "Normal",
			underline = "None",
			italic = false,
		},
	},
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	if tab.is_active then
		return {
			{ Text = tab.title },
		}
	end
end)

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },

	-- Pane keybindings
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
}
-- Return the final config
return config
