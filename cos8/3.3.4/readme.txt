3.3.2 patch https://github.com/qmtoaster/patches/tree/master/cos8/3.3.2

in addition the patches below (linked above).

last 3 patches:

Qmail Toaster 3.3.4 (qmail-1.03-3.3.4) consists of the 3.3.1 patched with the addition SMTP DEBUG and the Qualys' reccomendation:
   - SMTP debug patch: If env variable SMTP_DEBUG is set the SMTP client/server command transaction (with pid) is logged throughout
   - from client connection to server 221 (end of session) response. This is an update of the previous DEBUG patch to be less intrusive
   - to the qmail-smtpd.
   - Includes Qualys patch CVE-2005-1513 (https://www.qualys.com/2020/05/19/cve-2005-1513/remote-code-execution-qmail.txt).

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

