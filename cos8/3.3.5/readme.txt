3.3.4 patch: https://github.com/qmtoaster/patches/tree/master/cos8/3.3.4, additionally:

qt-smtp-command-debug.patch is replaced by qt-smtp-smtpd-debug-f2b.patch (link above).

   In order to log SMTP TX to different file you can stop qmail edit '/var/qmail/supervise/smtp/log/run' and replace everything with below, save
   and start qmail. Logs in such a way so that Fail to Ban can be used to reject connections from IP's that immediately disconnect :
      
      #!/bin/sh
      LOGSIZE=`cat /var/qmail/control/logsize`
      LOGCOUNT=`cat /var/qmail/control/logcount`
      exec /usr/bin/setuidgid qmaill \
        /usr/bin/multilog t s$LOGSIZE n$LOGCOUNT \
        '-*' '+@* server:[*' '+@* client:[*' /var/log/qmail/smtptx \
        '+*' '-@* server:[*' '-@* client:[*' /var/log/qmail/smtp 2>&1

# tail -f /var/log/qmail/smtptx/current | tai64nlocal
