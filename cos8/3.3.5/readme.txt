3.3.4 patch: https://github.com/qmtoaster/patches/tree/master/cos8/3.3.4, additionally:

qt-smtp-command-debug.patch is replaced by qt-smtp-smtpd-debug-f2b.patch (link above).

Notes:
   Several individuals in the Qmail Toaster community, myself included, have had duplicate 
   email deliveries, fortunately not often, because connections have died after email is 
   queued but before the final SMTP 'quit' command is issued by the client or the server's 
   221 response. This causes the delivering host to resend the email until the SMTP transaction 
   is complete. The SMTP debug patch will track client connection commands and server responses 
   from the beginning to the end of the SMTP session.
   
   With the most recent version of simscan (1.4.0-9) ppid is added to all output when evnvironment
   variable SIMSCAN_DEBUG="5" is defined. With SMTP_DEBUG (above) defined monitoring SMTP transactions 
   is simplified. 
   
   In order to log SMTP TX to different file you can stop qmail edit '/var/qmail/supervise/smtp/log/run' and replace everything with below, save
   and start qmail :
      
      #!/bin/sh
      LOGSIZE=`cat /var/qmail/control/logsize`
      LOGCOUNT=`cat /var/qmail/control/logcount`
      exec /usr/bin/setuidgid qmaill \
        /usr/bin/multilog t s$LOGSIZE n$LOGCOUNT \
        '-*' '+@* server:[*' '+@* client:[*' /var/log/qmail/smtptx \
        '+*' '-@* server:[*' '-@* client:[*' /var/log/qmail/smtp 2>&1

# tail -f /var/log/qmail/smtptx/current | tai64nlocal
