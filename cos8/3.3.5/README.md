Patches Applied:<br>
<a href="https://github.com/qmtoaster/patches/blob/master/cos8/3.3.1/qt-netqmail-1.06-1.0.1.patch">qt-netqmail-1.06-1.0.1.patch</a><br>
<a href="https://github.com/qmtoaster/patches/blob/master/cos8/3.3.5/qt-smtp-smtpd-debug-f2b.patch">qt-smtp-smtpd-debug-f2b.patch</a><br>
<a href="https://github.com/qmtoaster/patches/blob/master/cos8/3.3.4/qt-smtp-command-debug.patch">qt-smtp-command-debug.patch</a><br>
<a href="https://github.com/qmtoaster/patches/blob/master/cos8/3.3.4/qt-qualys.patch">qt-qualys.patch</a><br>

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
