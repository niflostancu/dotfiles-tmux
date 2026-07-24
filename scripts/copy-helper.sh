#!/bin/bash
text="$(cat)"
b64=$(printf '%s' "$text" | base64 -w0)

# Wayland clipboard
if command -v wl-copy &>/dev/null; then
	printf '%s' "$text" | wl-copy --primary
fi
# OSC-52 (VTE/GNOME/Terminator/etc.)
printf '\e]52;c;%s\e\\' "$b64"
