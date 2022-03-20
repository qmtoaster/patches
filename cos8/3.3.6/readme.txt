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
qt-smtp-tls13.patch (below)

patches 1 thru 35 are combined into one:  qt-netqmail-1.06-1.0.1.patch

OpenSSL 1.1.1 patch

--- qmail-1.03-3.3.5/qmail-remote.c     2022-03-18 08:22:01.810701523 -0600
+++ qmail-1.03-3.3.5-new/qmail-remote.c 2022-03-18 13:48:22.951868716 -0600
@@ -426,16 +426,26 @@
     }
   }

-  SSL_library_init();
-  ctx = SSL_CTX_new(SSLv23_client_method());
+#if OPENSSL_VERSION_NUMBER >= 0x10101000L
+   OPENSSL_init_ssl(OPENSSL_INIT_LOAD_SSL_STRINGS,NULL); /* TLS 1.3 */
+   ctx = SSL_CTX_new(TLS_client_method());
+#else
+   SSL_library_init();                                   /* TLS < 1.3 */
+   ctx = SSL_CTX_new(SSLv23_client_method());
+#endif
   if (!ctx) {
     if (!smtps && !servercert) return 0;
     smtptext.len = 0;
     tls_quit_error("ZTLS error initializing ctx");
   }

-  /* POODLE vulnerability */
+#if OPENSSL_VERSION_NUMBER >= 0x10101000L
+  SSL_CTX_set_options(ctx,SSL_OP_ALL);
+  SSL_CTX_set_min_proto_version(ctx,TLS1_VERSION);
+  SSL_CTX_set_max_proto_version(ctx,TLS1_3_VERSION);
+#else
   SSL_CTX_set_options(ctx, SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3);
+#endif

   if (servercert) {
     if (!SSL_CTX_load_verify_locations(ctx, servercert, NULL)) {
@@ -476,7 +486,11 @@
     ciphers = saciphers.s;
   }
   else ciphers = "DEFAULT";
-  SSL_set_cipher_list(myssl, ciphers);
+#if OPENSSL_VERSION_NUMBER >= 0x10101000L
+   SSL_set_ciphersuites(myssl,ciphers); /* TLS 1.3 */
+#else
+   SSL_set_cipher_list(myssl,ciphers);  /* TLS < 1.3 */
+#endif
   alloc_free(saciphers.s);

   SSL_set_fd(myssl, smtpfd);
--- qmail-1.03-3.3.5/tls.c      2022-03-18 08:22:02.507741854 -0600
+++ qmail-1.03-3.3.5-new/tls.c  2022-03-18 14:02:17.001103857 -0600
@@ -14,7 +14,9 @@
 {
   int r = ERR_get_error();
   if (!r) return NULL;
+#if OPENSSL_VERSION_NUMBER < 0x10101000L
   SSL_load_error_strings();
+#endif
   return ERR_error_string(r, NULL);
 }
 const char *ssl_error_str()
--- qmail-1.03-3.3.5/qmail-smtpd.c      2022-03-18 08:22:01.827702507 -0600
+++ qmail-1.03-3.3.5-new/qmail-smtpd.c  2022-03-18 14:41:30.512190971 -0600
@@ -1469,14 +1469,22 @@
   X509_LOOKUP *lookup;
   int session_id_context = 1; /* anything will do */

-  SSL_library_init();
-
-  /* a new SSL context with the bare minimum of options */
+#if OPENSSL_VERSION_NUMBER >= 0x10101000L
+  OPENSSL_init_ssl(OPENSSL_INIT_LOAD_SSL_STRINGS,NULL); /* TLS 1.3 */
+  ctx = SSL_CTX_new(TLS_server_method());
+#else
+  SSL_library_init();                                   /* TLS < 1.3 */
   ctx = SSL_CTX_new(SSLv23_server_method());
+#endif
   if (!ctx) { tls_err("unable to initialize ctx"); return; }

-  /* POODLE vulnerability */
+#if OPENSSL_VERSION_NUMBER >= 0x10101000L
+  SSL_CTX_set_options(ctx,SSL_OP_ALL);
+  SSL_CTX_set_min_proto_version(ctx,TLS1_VERSION);
+  SSL_CTX_set_max_proto_version(ctx,TLS1_3_VERSION);
+#else
   SSL_CTX_set_options(ctx, SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3);
+#endif

   /* renegotiation should include certificate request */
   SSL_CTX_set_options(ctx, SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION);
@@ -1529,7 +1537,11 @@
     }
   }
   if (!ciphers || !*ciphers) ciphers = "DEFAULT";
-  SSL_set_cipher_list(myssl, ciphers);
+#if OPENSSL_VERSION_NUMBER >= 0x10101000L
+  SSL_set_ciphersuites(myssl,ciphers); /* TLS 1.3 */
+#else
+  SSL_set_cipher_list(myssl,ciphers);  /* TLS < 1.3 */
+#endif
   alloc_free(saciphers.s);

   SSL_set_tmp_rsa_callback(myssl, tmp_rsa_cb); 
