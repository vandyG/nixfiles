{
	settings = {
		format = "[](color_orange)$os$username[](bg:color_yellow fg:color_orange)$directory[](fg:color_yellow bg:color_aqua)$git_branch$git_status[](fg:color_aqua bg:color_blue)$c$cpp$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:color_blue bg:color_bg3)$docker_context$conda$pixi[](fg:color_bg3 bg:color_bg1)$time[ ](fg:color_bg1)$line_break$character";

		palette = "gruvbox_dark";

		os.style = "bg:color_orange fg:color_fg0";

		username = {
			style_user = "bg:color_orange fg:color_fg0";
			style_root = "bg:color_orange fg:color_fg0";
			format = "[ $user ]($style)";
		};

		directory = {
			style = "fg:color_fg0 bg:color_yellow";
			format = "[ $path ]($style)";
		};

		git_branch = {
			symbol = "";
			style = "bg:color_aqua";
			format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
		};

		git_status = {
			style = "bg:color_aqua";
			format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
		};

		nodejs = {
			symbol = "";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		c = {
			symbol = " ";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		cpp = {
			symbol = " ";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		rust = {
			symbol = "";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		golang = {
			symbol = "";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		php = {
			symbol = "";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		java = {
			symbol = "";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		kotlin = {
			symbol = "";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		haskell = {
			symbol = "";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		python = {
			symbol = "";
			style = "bg:color_blue";
			format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		};

		docker_context = {
			symbol = "";
			style = "bg:color_bg3";
			format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
		};

		conda = {
			symbol = "";
			style = "bg:color_bg3";
			format = "[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)";
		};

		pixi = {
			symbol = "";
			style = "bg:color_bg3";
			format = "[[ $symbol( $version)( $environment) ](fg:color_fg0 bg:color_bg3)]($style)";
		};

		time = {
			style = "bg:color_bg1";
			format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
		};

		line_break.disabled = false;

		character = {
			disabled = false;
			success_symbol = "[](bold fg:color_green)";
			error_symbol = "[](bold fg:color_red)";
			vimcmd_symbol = "[](bold fg:color_green)";
			vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
			vimcmd_replace_symbol = "[](bold fg:color_purple)";
			vimcmd_visual_symbol = "[](bold fg:color_yellow)";
		};

		palettes.gruvbox_dark = {
			color_fg0 = "#fbf1c7";
			color_bg1 = "#3c3836";
			color_bg3 = "#665c54";
			color_blue = "#458588";
			color_aqua = "#689d6a";
			color_green = "#98971a";
			color_orange = "#d65d0e";
			color_purple = "#b16286";
			color_red = "#cc241d";
			color_yellow = "#d79921";
		};
	};
}
