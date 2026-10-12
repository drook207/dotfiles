# Print the WSL path of 1Password's op-ssh-sign-wsl.exe (Windows app), if installed
win=$(cmd.exe /c "echo %LOCALAPPDATA%" 2>/dev/null | tr -d "\r")
[ -n "$win" ] || exit 0
p="$(wslpath "$win" 2>/dev/null)/1Password/app/8/op-ssh-sign-wsl.exe"
[ -f "$p" ] && printf "%s" "$p"
exit 0
