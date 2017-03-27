# LinuxAdminStuff
These are commands/settings i usually use for Admin duties.



# Disk Health
`smartctl -a /dev/sda`
#### /etc/smartd.conf
`/dev/sdb -a -o on -S on -s (S/../.././02|L/../../6/03) -m coral-admin-list@lehigh.edu`


# Sed with hostname variable:
<p><code>for i in `seq 2 15`; do ssh polyp$i 'sed -i "s/polyp1/$HOSTNAME/g" /etc/exim4/exim4.conf.template';done</code></p>


# Memory check
<p><code>`for i in \`seq 2 15\`; do ssh polyp$i 'hostname;free -h'; done`</code></p>


# Torque - Schedulder
 Show stats:
 `/usr/local/maui/bin/showstats -n`
 
 Show server/queue settings:
 `qmgr -c 'p s'`
 See Jobs logs:
`tracejob $PID`
# Delete a week old installs
### we are installing daily so need to clean out builds of last week 

`typeset -RZ3 i; for i in {1..38}; do ssh "grid$i" "hostname; find /folder/of/installs/* -type d -ctime +7 -maxdepth 0 | xargs rm -rf "& ; done`
### CRON  Weekly
`0  7 * * 6 `
