3.3.4 patch: https://github.com/qmtoaster/patches/tree/master/cos8/3.3.4, additionally:

qt-smtp-command-debug.patch is replaced by qt-smtp-smtpd-debug-f2b.patch (link above).

   In order to log SMTP transactions do the following:
   1) # qmailctl stop
   2) Add 'SMTP_DEBUG="1"' to /etc/tcprules.d/tcp.smtp 
   3) Replace contents of '/var/qmail/supervise/smtp/log/run' script with below to log transactions to different file: 
      
      #!/bin/sh
      LOGSIZE=`cat /var/qmail/control/logsize`
      LOGCOUNT=`cat /var/qmail/control/logcount`
      exec /usr/bin/setuidgid qmaill \
        /usr/bin/multilog t s$LOGSIZE n$LOGCOUNT \
        '-*' '+@* server:[*' '+@* client:[*' /var/log/qmail/smtptx \
        '+*' '-@* server:[*' '-@* client:[*' /var/log/qmail/smtp 2>&1
   4) # qmailctl start && qmailctl cdb
   5) # tail -f /var/log/qmail/smtptx/current | tai64nlocal

Fail2Ban can be used to block IP's trying to authorize outside TLS, the log entry is in the following form:
    503 auth not available (#5.3.3) - xxx.xxx.xxx.xxx 
This format can be added to Fail2Ban to block the associated IP address. See http://qmailtoaster.com/fail2ban.html 
