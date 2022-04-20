# Debian steamrun

This scripts was my update and runtime helper for the first Steam version on Linux. 
So the script installs the Steam libs and I was able to run steam from console on Debian GNU Linux.

## Notes

This project is from 2013 and is no longer developed or maintained.

## INSTALL

You can run the script manually or link it to may `/usr/bin`.

## RUN

1. start a terminal (e.g.: [xterm](https://invisible-island.net/xterm/xterm.html))
2. run the script (e.g.: `./steamrun`)

## PROBLEMS

There exists some libraries update problems. So you have to run 
```bash
root# aptitude safe-upgrade --full-resolver -y
``` 

- this will uninstall steam 
- upgrade the system
- you have to run `./steamrun` again (but the libs are cached!)
