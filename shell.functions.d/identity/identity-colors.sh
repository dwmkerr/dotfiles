#!/usr/bin/env bash
# identity-colors.sh — the identity colour map.
#
# Shared by the PS1 badge and the Claude Code statusline. Kept in one place
# because two copies drifted: an unrecognised colour rendered white in the
# prompt and green in the statusline, and "pink" was in an identity file that
# neither map handled.

# Map an identity colour name to an ANSI colour index (0-7). Callers render it
# themselves - `tput setaf N` for terminfo, or 30+N for a raw SGR escape.
identity_color_index() {
    case "${1:-white}" in
        black)          echo 0 ;;
        red)            echo 1 ;;
        green)          echo 2 ;;
        yellow)         echo 3 ;;
        blue)           echo 4 ;;
        magenta|pink)   echo 5 ;;
        cyan)           echo 6 ;;
        white|grey|gray) echo 7 ;;
        *)              echo 7 ;;
    esac
}
