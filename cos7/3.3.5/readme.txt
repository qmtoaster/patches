01.q103-to-nq106.patch 
02.chkuser-2.0.9-release.adj.patch 
03.qmail-vpopmail-devel.adj.patch 
04.big-concurrency-fix.patch
05.big-concurrency.patch 
06.custom.patch 
07.netqmail-maildir++.patch 
08.qmail-taps-extended-full.adj.patch 
09.qmail-spf-rc5.adj.patch 
10.qmail-warlord.patch 
11.qmail-canonical.rcpt.patch 
12.qregex-20060423.adj.patch 
13.netqmail-1.06-tls-1.1.2-20200107.adj.patch 
14.auth83.v2.adj.patch 
15.force-tls_marcel.adj.patch 
16.qmailtoaster-chkuser.patch 
17.qmail-smtpd-spf-qq-reject-logging.adj.patch 
18.qmail-srs-0.8.adj.patch 
19.qmailtoaster-big-dns.patch 
20.qmail-smtpd-linefeed.adj.patch 
21.qmail-empf.adj.patch 
22.qmail-uids.patch 
23.qmail-rm-cname.adj.patch 
24.qmail-maildir++-size.patch 
25.qmail-addrparse.patch 
26.ext_todo-20030105.adj.patch 
27.qmail-remote-rfc2821.patch 
28.qmail-smtpd-502-to-500.patch 
29.qmail-remote-crlf.patch 
30.qmail-1.03-reread-concurrency.2.patch 
31.qmail-smtpd-pidqplog.patch 
32.qmail-smtpd-relay-reject.adj.patch 
33.doublebounce-trim.patch
34.qmail-inject-null-sender.patch 
35.spamthrottle-2.03.patch
qt-qualys.patch
qt-smtp-command-debug.patch
qt-smtp-smtpd-debug-f2b.patch

patches 1 thru 35 are combined into one:  qt-netqmail-1.06-1.0.1.patch

last 3 patches:

Qmail Toaster 3.3.4 (qmail-1.03-3.3.4) consists of the 3.3.1 patched with the addition SMTP DEBUG and the Qualys' reccomendation:
   - SMTP debug patch: If env variable SMTP_DEBUG is set the SMTP client/server command transaction (with pid) is logged throughout
   - from client connection to server 221 (end of session) response. This is an update of the previous DEBUG patch to be less intrusive
   - to the qmail-smtpd. Additionall it addes IP address when auth login is requested outside tls so that the host can be blocked by fail2ban
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
