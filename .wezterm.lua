-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
--

local copy_mode = nil
if wezterm.gui then
	copy_mode = wezterm.gui.default_key_tables().copy_mode
	table.insert(copy_mode, { key = "c", mods = "NONE", action = act.CopyMode("MoveLeft") })
	table.insert(copy_mode, { key = "t", mods = "NONE", action = act.CopyMode("MoveDown") })
	table.insert(copy_mode, { key = "s", mods = "NONE", action = act.CopyMode("MoveUp") })
	table.insert(copy_mode, { key = "r", mods = "NONE", action = act.CopyMode("MoveRight") })
	table.insert(copy_mode, { key = "é", mods = "NONE", action = act.CopyMode("MoveForwardWord") })
end

-- For example, changing the color scheme:
config.color_scheme = "Tokyo Night Moon"

config.font = wezterm.font("Iosevka Term")
config.font_size = 14

config.hide_tab_bar_if_only_one_tab = false

config.scrollback_lines = 100000

config.mouse_bindings = {
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("PrimarySelection"),
	},
	-- Bind 'Up' event of CTRL-Click to open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.Nop,
	},
}

config.disable_default_key_bindings = true
config.keys = {
	{ key = "I", mods = "CTRL|SHIFT", action = act.SpawnWindow },

	-- splits
	{
		key = "e",
		mods = "CTRL|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "o",
		mods = "CTRL|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- tabs
	-- create tab
	{
		key = "T",
		mods = "CTRL|SHIFT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},

	-- move between panes
	{
		key = "LeftArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "ALT",
		action = act.ActivatePaneDirection("Down"),
	},

	-- resize panes
	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 2 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 2 }),
	},
	{
		key = "UpArrow",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 2 }),
	},
	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 2 }),
	},

	-- toggle pane zoom
	{
		key = "X",
		mods = "CTRL",
		action = act.TogglePaneZoomState,
	},

	-- paste from clipboard
	{
		key = "V",
		mods = "CTRL|SHIFT",
		action = act.PasteFrom("Clipboard"),
	},

	-- paste from the primary selection
	{
		key = "V",
		mods = "ALT|SHIFT",
		action = act.PasteFrom("PrimarySelection"),
	},

	-- scrolls
	{
		key = "PageUp",
		mods = "SHIFT",
		action = act.ScrollByPage(-1),
	},
	{
		key = "PageDown",
		mods = "SHIFT",
		action = act.ScrollByPage(1),
	},

	-- { key = "s", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(-1) },
	-- { key = "t", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(1) },

	-- { key = "l", mods = "ALT|SHIFT",  action = act.ActivateCopyMode },

	-- display hints to open links with a keyboard key
	{
		key = "L",
		mods = "SHIFT|CTRL",
		action = act.QuickSelectArgs({
			label = "open url",
			patterns = {
				"https?://\\S+",
			},
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.log_info("opening: " .. url)
				wezterm.open_with(url)
			end),
		}),
	},

	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "PageUp", mods = "SHIFT|CTRL", action = act.MoveTabRelative(-1) },
	{ key = "PageDown", mods = "SHIFT|CTRL", action = act.MoveTabRelative(1) },

	{ key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
	{ key = "!", mods = "CTRL", action = act.ActivateTab(0) },
	{ key = "!", mods = "SHIFT|CTRL", action = act.ActivateTab(0) },
	{ key = '"', mods = "ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = '"', mods = "SHIFT|ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "#", mods = "CTRL", action = act.ActivateTab(2) },
	{ key = "#", mods = "SHIFT|CTRL", action = act.ActivateTab(2) },
	{ key = "$", mods = "CTRL", action = act.ActivateTab(3) },
	{ key = "$", mods = "SHIFT|CTRL", action = act.ActivateTab(3) },
	{ key = "%", mods = "CTRL", action = act.ActivateTab(4) },
	{ key = "%", mods = "SHIFT|CTRL", action = act.ActivateTab(4) },
	{ key = "%", mods = "ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "SHIFT|ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "&", mods = "CTRL", action = act.ActivateTab(6) },
	{ key = "&", mods = "SHIFT|CTRL", action = act.ActivateTab(6) },
	{ key = "'", mods = "SHIFT|ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "(", mods = "CTRL", action = act.ActivateTab(-1) },
	{ key = "(", mods = "SHIFT|CTRL", action = act.ActivateTab(-1) },
	{ key = ")", mods = "CTRL", action = act.ResetFontSize },
	{ key = ")", mods = "SHIFT|CTRL", action = act.ResetFontSize },
	{ key = "*", mods = "CTRL", action = act.ActivateTab(7) },
	{ key = "*", mods = "SHIFT|CTRL", action = act.ActivateTab(7) },
	{ key = "+", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "-", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
	{ key = "-", mods = "SUPER", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	{ key = "0", mods = "SHIFT|CTRL", action = act.ResetFontSize },
	{ key = "0", mods = "SUPER", action = act.ResetFontSize },
	{ key = "1", mods = "SHIFT|CTRL", action = act.ActivateTab(0) },
	{ key = "1", mods = "SUPER", action = act.ActivateTab(0) },
	{ key = "2", mods = "SHIFT|CTRL", action = act.ActivateTab(1) },
	{ key = "2", mods = "SUPER", action = act.ActivateTab(1) },
	{ key = "3", mods = "SHIFT|CTRL", action = act.ActivateTab(2) },
	{ key = "3", mods = "SUPER", action = act.ActivateTab(2) },
	{ key = "4", mods = "SHIFT|CTRL", action = act.ActivateTab(3) },
	{ key = "4", mods = "SUPER", action = act.ActivateTab(3) },
	{ key = "5", mods = "SHIFT|CTRL", action = act.ActivateTab(4) },
	{ key = "5", mods = "SHIFT|ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "5", mods = "SUPER", action = act.ActivateTab(4) },
	{ key = "6", mods = "SHIFT|CTRL", action = act.ActivateTab(5) },
	{ key = "6", mods = "SUPER", action = act.ActivateTab(5) },
	{ key = "7", mods = "SHIFT|CTRL", action = act.ActivateTab(6) },
	{ key = "7", mods = "SUPER", action = act.ActivateTab(6) },
	{ key = "8", mods = "SHIFT|CTRL", action = act.ActivateTab(7) },
	{ key = "8", mods = "SUPER", action = act.ActivateTab(7) },
	{ key = "9", mods = "SHIFT|CTRL", action = act.ActivateTab(-1) },
	{ key = "9", mods = "SUPER", action = act.ActivateTab(-1) },
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "=", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
	{ key = "=", mods = "SUPER", action = act.IncreaseFontSize },
	{ key = "@", mods = "CTRL", action = act.ActivateTab(1) },
	{ key = "@", mods = "SHIFT|CTRL", action = act.ActivateTab(1) },
	{ key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
	{ key = "E", mods = "CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "F", mods = "CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "F", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "I", mods = "CTRL", action = act.SpawnWindow },
	{ key = "K", mods = "CTRL", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "K", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
	{
		key = "L",
		mods = "CTRL",
		action = act.QuickSelectArgs({
			action = { EmitEvent = "user-defined-0" },
			alphabet = "",
			label = "open\u{20}url",
			patterns = { "https?://\\S+" },
		}),
	},
	{ key = "M", mods = "CTRL", action = act.Hide },
	{ key = "M", mods = "SHIFT|CTRL", action = act.Hide },
	{ key = "N", mods = "CTRL", action = act.SpawnWindow },
	{ key = "N", mods = "SHIFT|CTRL", action = act.SpawnWindow },
	{ key = "O", mods = "CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "P", mods = "CTRL", action = act.ActivateCommandPalette },
	{ key = "P", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
	{ key = "R", mods = "CTRL", action = act.ReloadConfiguration },
	{ key = "R", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
	{ key = "T", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
	{
		key = "U",
		mods = "CTRL",
		action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
	},
	{
		key = "U",
		mods = "SHIFT|CTRL",
		action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
	},
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "V", mods = "ALT", action = act.PasteFrom("PrimarySelection") },
	{ key = "W", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "X", mods = "CTRL", action = act.TogglePaneZoomState },
	{ key = "Z", mods = "CTRL", action = act.TogglePaneZoomState },
	{ key = "Z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
	{ key = "^", mods = "CTRL", action = act.ActivateTab(5) },
	{ key = "^", mods = "SHIFT|CTRL", action = act.ActivateTab(5) },
	{ key = "_", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
	{ key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
	{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
	{ key = "f", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "f", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "k", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "m", mods = "SHIFT|CTRL", action = act.Hide },
	{ key = "m", mods = "SUPER", action = act.Hide },
	{ key = "n", mods = "SHIFT|CTRL", action = act.SpawnWindow },
	{ key = "n", mods = "SUPER", action = act.SpawnWindow },
	{ key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
	{ key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
	{ key = "r", mods = "SUPER", action = act.ReloadConfiguration },
	{ key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
	{
		key = "u",
		mods = "SHIFT|CTRL",
		action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
	},
	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
	{ key = "w", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
	{ key = "phys:Space", mods = "SHIFT|CTRL", action = act.QuickSelect },
	{ key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "LeftArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Left", 2 }) },
	{ key = "LeftArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "RightArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Right", 2 }) },
	{ key = "RightArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "UpArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Up", 2 }) },
	{ key = "UpArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "DownArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Down", 2 }) },
	{ key = "DownArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "Insert", mods = "SHIFT", action = act.PasteFrom("PrimarySelection") },
	{ key = "Insert", mods = "CTRL", action = act.CopyTo("PrimarySelection") },
	{ key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
	{ key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },
}

config.key_tables = {
	copy_mode = copy_mode,
}

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- and finally, return the configuration to wezterm
return config
