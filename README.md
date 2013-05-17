Installs a script to run steam from console  on Debian GNU Linux.

INSTALL
-------------------------------------------------------------------------------
run script manually or link it to /usr/bin

RUN
-------------------------------------------------------------------------------
1. start a terminal (Example: xterm)
2. run the script (Example: ./steamrun)

PROBLEMS
-------------------------------------------------------------------------------
Library update problems.
do 
# aptitude safe-upgrade --full-resolver -y 
-> this will uninstall steam every time and do the updates
-> the steamlibs and debs are cached
