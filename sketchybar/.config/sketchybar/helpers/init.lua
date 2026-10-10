-- Adapted from FelixKratz/dotfiles (GPL-3.0).
-- Adds the sbarlua module to the package cpath.
-- (No C helper binaries are built — the menus popup system is not vendored.)
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
