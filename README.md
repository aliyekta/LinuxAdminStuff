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


# torque 
 Show stats:
 `/usr/local/maui/bin/showstats -n`
 
 Show server/queue settings:
 `qmgr -c 'p s'`
 See Jobs logs:
`tracejob $PID`
