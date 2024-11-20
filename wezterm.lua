local wezterm = require("wezterm")
local gui = wezterm.gui
local act = wezterm.action
local font = wezterm.font

local config = {}
local mouse_bindings = {}
local launch_menu = {}

<<<<<<< HEAD
=======
-- Icon mappings for processes and directories
local icon_mappings = {
	processes = {
		nvim = wezterm.nerdfonts.custom_neovim,
		zsh = wezterm.nerdfonts.cod_terminal,
		bash = wezterm.nerdfonts.cod_terminal_bash,
		git = wezterm.nerdfonts.fa_git,
	},
	extensions = {
		[".lua"] = wezterm.nerdfonts.md_language_lua,
		[".svelte"] = wezterm.nerdfonts.seti_svelte,
		[".js"] = wezterm.nerdfonts.dev_javascript,
		[".rb"] = wezterm.nerdfonts.dev_ruby,
		[".go"] = wezterm.nerdfonts.custom_go,
		[".py"] = wezterm.nerdfonts.dev_python,
		[".ts"] = wezterm.nerdfonts.dev_typescript,
		[".html"] = wezterm.nerdfonts.dev_html5,
		[".css"] = wezterm.nerdfonts.dev_css3,
	},
	directories = {
		Documents = wezterm.nerdfonts.fa_folder_open,
		Projects = wezterm.nerdfonts.dev_code,
		Downloads = wezterm.nerdfonts.fa_download,
		Music = wezterm.nerdfonts.fa_music,
		Pictures = wezterm.nerdfonts.fa_image,
		Videos = wezterm.nerdfonts.fa_video,
		OneDrive = wezterm.nerdfonts.dev_onedrive,
	},
	default_icon = wezterm.nerdfonts.cod_file,
}

-- Function to dynamically set icons in tab titles
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	local process_name = tab.active_pane.foreground_process_name

	-- Check if there's an icon for the process
	for proc, icon in pairs(icon_mappings.processes) do
		if process_name and process_name:find(proc) then
			title = icon .. " " .. title
			return title
		end
	end
end)

>>>>>>> 7fcd62c (fix(wezterm): 🔧 improve customization for better appearance)
-- Uncomment this block if you want to display a status bar with date, time, and battery info.
-- The status bar is set to display on the right side of the terminal window.
-- wezterm.on("update-right-status", function(window, pane)
--   local date = wezterm.strftime("%a %-d %b %y %H:%M ")
--   local bat = ""
--
--   for _, b in ipairs(wezterm.battery_info()) do
--     bat = wezterm.nerdfonts.md_battery .. " " .. string.format("%.0f%%", b.state_of_charge * 100)
--   end
--
--   -- Set the right status to the date and battery status of the current pane in the window
--   window:set_right_status(wezterm.format({
--     { Text = " | " .. wezterm.nerdfonts.fa_clock_o .. " " .. date .. " | " .. bat .. "  | " },
--   }))
--
--   -- Optionally, you can also set a left status with the terminal title or other info.
--   window:set_left_status(wezterm.format({
--     { Text = " | " .. wezterm.nerdfonts.fa_terminal .. " " .. pane.title .. " | " },
--   }))
-- end)

-- Use the `wezterm` module to build the configuration if supported
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Define the launch menu items
config.launch_menu = launch_menu

-- Disable the tab bar as it’s not needed; setting it at the bottom if enabled
<<<<<<< HEAD
config.enable_tab_bar = false
config.tab_bar_at_bottom = false

=======
config.enable_tab_bar = true
config.tab_bar_at_bottom = false

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- Get the current working directory of the active pane
	local cwd_uri = tab.active_pane.current_working_dir
	local cwd = ""

	-- Convert the URI to a more readable path, if available
	if cwd_uri then
		local home = os.getenv("HOME")
		cwd = cwd_uri:match("file://[^/]*(/.*)")
		if home and cwd == home then
			cwd = "~"
		elseif home and cwd:find(home, 1, true) == 1 then
			cwd = "~" .. cwd:sub(#home + 1)
		end
	end

	local title = " " .. cwd .. " "

	if tab.is_active then
		return {
			{ Background = { Color = "#7aa2f7" } },
			{ Foreground = { Color = "#24283b" } },
			{ Foreground = { Color = "#1a1b26" } },
			{ Text = title },
			{ Foreground = { Color = "#24283b" } },
		}
	else
		return {
			{ Background = { Color = "#1a1b26" } },
			{ Foreground = { Color = "#24283b" } },
			{ Foreground = { Color = "#a9b1d6" } },
			{ Text = title },
			{ Foreground = { Color = "#24283b" } },
		}
	end
end)

-- Tokyo Night Storm colors with custom styling for tabs
config.colors = {
	tab_bar = {
		background = "#24283b",

		-- Active tab styling
		active_tab = {
			bg_color = "#7aa2f7",
			fg_color = "#1a1b26",
			intensity = "Bold",
		},

		-- Inactive tab styling
		inactive_tab = {
			bg_color = "#1a1b26",
			fg_color = "#a9b1d6",
		},

		-- Hover effect for inactive tabs
		inactive_tab_hover = {
			bg_color = "#3b4261",
			fg_color = "#c0caf5",
			italic = true,
		},

		-- New tab styling
		new_tab = {
			bg_color = "#24283b",
			fg_color = "#7aa2f7",
		},

		-- New tab hover styling
		new_tab_hover = {
			bg_color = "#7aa2f7",
			fg_color = "#1a1b26",
			underline = "Single",
		},
	},
}

config.window_padding = {
	left = 1,
	right = 1,
	top = 0,
	bottom = 0,
}

>>>>>>> 7fcd62c (fix(wezterm): 🔧 improve customization for better appearance)
-- Function to get the current system appearance (e.g., Dark or Light mode)
local function get_appearance()
	if gui then
		return gui.get_appearance()
	end
<<<<<<< HEAD
	return "Dark"  -- Default to Dark if GUI isn't available
=======
	return "Dark" -- Default to Dark if GUI isn't available
>>>>>>> 7fcd62c (fix(wezterm): 🔧 improve customization for better appearance)
end

-- Select a color scheme based on the system appearance
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
<<<<<<< HEAD
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
=======
		return "tokyonight_storm"
	else
		return "tokyonight_night"
>>>>>>> 7fcd62c (fix(wezterm): 🔧 improve customization for better appearance)
	end
end

-- Customize various settings for a better appearance and readability
config.line_height = 1.2
config.font = wezterm.font_with_fallback({
<<<<<<< HEAD
	{ family = "CaskaydiaCove Nerd Font", scale = 1.4, weight = "Medium" },  -- Main font with medium weight
	{ family = "FiraCode Nerd Font", scale = 1.4 },  -- Fallback font
=======
	{ family = "CaskaydiaCove Nerd Font", scale = 1.2, weight = "Medium" }, -- Main font with medium weight
	{ family = "FiraCode Nerd Font", scale = 1.2 }, -- Fallback font
>>>>>>> 7fcd62c (fix(wezterm): 🔧 improve customization for better appearance)
})
config.color_scheme = scheme_for_appearance(get_appearance())

-- Uncomment and set the following options if you want a custom background image
-- config.window_background_image = "/path/to/wallpaper.png"
-- config.window_background_image_hsb = {
--   hue = 1.0,
--   saturation = 1.0,
--   brightness = 0.3,
-- }

-- Set the cursor style and window opacity
config.default_cursor_style = "BlinkingBar"
<<<<<<< HEAD
config.window_background_opacity = 0.6
=======
config.window_background_opacity = 0.9
>>>>>>> 7fcd62c (fix(wezterm): 🔧 improve customization for better appearance)

-- Set window decorations and behavior
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3500
config.default_workspace = "main"
config.enable_scroll_bar = true

-- Customize the appearance of the window frame
config.window_frame = {
	font = font({ family = "CaskaydiaCove Nerd Font", weight = "Bold" }),
	font_size = 14.0,
	-- active_titlebar_bg = "#2E3440",  -- Uncomment to set active title bar background color
	-- inactive_titlebar_bg = "#2E3440",  -- Uncomment to set inactive title bar background color
}

-- Brighten the foreground text for better contrast against the background
config.foreground_text_hsb = {
	hue = 1.0,
	saturation = 1.2,
	brightness = 1.5,
}

-- Adjust the appearance of inactive panes to differentiate them from active panes
config.inactive_pane_hsb = {
	hue = 0.0,
	saturation = 0.25,
	brightness = 0.5,
}

-- Keybindings settings: Disable default bindings and define custom ones
config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Leader key configuration for quick access to commonly used actions
	{ key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },

	-- Pane management keybindings
	{ key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	-- Resizing panes using a dedicated key table
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

	-- Moving tabs within the terminal window
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	{ key = "{", mods = "LEADER|ALT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER|ALT", action = act.MoveTabRelative(1) },

	-- Tab management keybindings
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },

	-- Rename the current tab
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

	-- Clipboard actions for copy and paste
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "c", mods = "CTRL", action = act.CopyTo("ClipboardAndPrimarySelection") },

	-- Workspace management
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

-- Additional keybindings for direct tab activation (e.g., LDR 1 for the first tab)
for i = 1, 9 do
	table.insert(config.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
end

-- Define key tables for resize and move tab actions
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

-- Mouse bindings: Customize mouse actions, like triple-click to select text
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

-- Return the final configuration table
return config
