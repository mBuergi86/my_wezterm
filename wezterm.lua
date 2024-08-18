local wezterm = require("wezterm")
local gui = wezterm.gui
local act = wezterm.action
local font = wezterm.font

local config = {}
local mouse_bindings = {}
local launch_menu = {}

-- Not need a tab bar and not TO DO
-- Set the window right status
--wezterm.on("update-right-status", function(window, pane)
--	local date = wezterm.strftime("%a %-d %b %y %H:%M ")
--	local bat = ""
--
--	for _, b in ipairs(wezterm.battery_info()) do
--		bat = wezterm.nerdfonts.md_battery .. " " .. string.format("%.0f%%", b.state_of_charge * 100)
--	end
--
--	-- Set the right status to the date and battery status of the current pane in the window
--	window:set_right_status(wezterm.format({
--		{ Text = " | " .. wezterm.nerdfonts.fa_clock_o .. " " .. date .. " | " .. bat .. "  | " },
--	}))
--
--	window:set_left_status(wezterm.format({
--		{ Text = " | " .. wezterm.nerdfonts.fa_terminal .. " " .. pane.title .. " | " },
--	}))
--end)

-- Use the `wezterm` module to provide config
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.launch_menu = launch_menu
-- tab bar is disabled
config.enable_tab_bar = false
config.tab_bar_at_bottom = false

-- Get the current appearance
local function get_appearance()
	if gui then
		return gui.get_appearance()
	end
	return "Dark"
end

-- Determine the color scheme based on the appearance
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

-- Settings for a customization
config.line_height = 1.2
config.font = wezterm.font_with_fallback({
	{ family = "CaskaydiaCove Nerd Font", scale = 1.4, weight = "Medium" },
	{ family = "FiraCode Nerd Font", scale = 1.4 },
})
config.color_scheme = scheme_for_appearance(get_appearance())
--config.window_background_image = "/path/to/wallpaper.png"
--config.window_background_image_hsb = {
--	hue = 1.0,
--	saturation = 1.0,
--	brightness = 0.3,
--}
config.default_cursor_style = "BlinkingBar"
config.window_background_opacity = 0.6
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3500
config.default_workspace = "main"
config.enable_scroll_bar = true

config.window_frame = {
	font = font({ family = "CaskaydiaCove Nerd Font", weight = "Bold" }),
	font_size = 14.0,
	-- active_titlebar_bg = "#2E3440",
	-- inactive_titlebar_bg = "#2E3440",
}

-- This is used to make my foreground text color brighter than the background
config.foreground_text_hsb = {
	hue = 1.0,
	saturation = 1.2,
	brightness = 1.5,
}

-- This is switch a pane different color when it is inactive and active
config.inactive_pane_hsb = {
	hue = 0.0,
	saturation = 0.25,
	brightness = 0.5,
}

-- Settings for Keys
config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },

	-- Panes for new window about horizontal and vertical
	{ key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Panes movement
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	-- another pane close
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	-- which pane will zoom
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	-- resizing panes
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
	-- moving tabs
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	-- or shortcuts to move tab w/o move_tab table. ALT is for when caps lock is on
	{ key = "{", mods = "LEADER|ALT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER|ALT", action = act.MoveTabRelative(1) },

	-- Tab keybindings
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },

	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
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
		}),
	},

	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "c", mods = "CTRL", action = act.CopyTo("ClipboardAndPrimarySelection") },

	-- Lastly, workspace
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

-- it can use the tab navigator (LDR t)
for i = 1, 9 do
	table.insert(config.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
end

-- Key tables
config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

-- Mouse bindings
config.mouse_bindings = mouse_bindings
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

-- Return the final config
return config
