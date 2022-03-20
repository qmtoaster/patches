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
