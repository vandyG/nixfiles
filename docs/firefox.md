# Firefox customization

This repository includes two Firefox customization paths:

- Firefox theming via the Firefox Color extension.
- Website theming via the Stylus extension.

The bundled assets live here:

- [Firefox theme package](../modules/templates/firefox/catppuccin-theme/)
- [Stylus userstyle import](../modules/templates/firefox/import.json)

## Firefox profile template

Use `nix-vandy initff <firefox-profile-dir>` to copy the managed [Firefox user.js template](../modules/templates/firefox/user.js) into the profile directory you actually use.

The template disables a set of Firefox AI-related features and keeps the browser profile aligned with the rest of this repository's Firefox customization setup.

Typical flow:

1. Find the Firefox profile directory on your system.
2. Run `nix-vandy initff <firefox-profile-dir>`.
3. Confirm that `user.js` was written into that profile directory before importing themes or userstyles.

## Firefox Color theme

Use the Firefox Color extension to apply the bundled Catppuccin browser theme:

- Firefox Color extension: https://addons.mozilla.org/en-GB/firefox/addon/firefox-color/
- Catppuccin Firefox guide: https://github.com/catppuccin/firefox

Typical flow:

1. Install Firefox Color from the extension page.
2. Open the Catppuccin Firefox theme package in [modules/templates/firefox/catppuccin-theme/](../modules/templates/firefox/catppuccin-theme/).
3. Import or apply the theme through Firefox Color following the Catppuccin Firefox instructions.
4. Verify the color changes on the browser chrome, tabs, toolbar, and new tab page.

## Stylus userstyle

Use the Stylus extension to apply the bundled Catppuccin website userstyle:

- Stylus extension: https://addons.mozilla.org/en-GB/firefox/addon/styl-us/
- Stylus usage guide: https://userstyles.catppuccin.com/getting-started/usage/

Typical flow:

1. Install Stylus from the extension page.
2. Open the Catppuccin userstyle import data in [modules/templates/firefox/import.json](../modules/templates/firefox/import.json).
3. Import the style into Stylus following the Catppuccin userstyle guide.
4. Enable the style for the sites you want to theme.

## Notes

- Import the theme and userstyle into the Firefox profile you actually use.
- Keep the relevant extensions enabled for that profile.
- If a site is not themed, check whether the site is supported by the Catppuccin userstyle or needs a separate style rule.