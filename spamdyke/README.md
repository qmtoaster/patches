Spamdyke OpenSSL 1.1.1 <a href="https://github.com/qmtoaster/patches/blob/master/spamdyke/spamdyke-openssl.patch">Patch</a>
spamdyke >= 5.0.1-3, EL >= 8 add below line to spamdyke.conf otherwise spamdyke will not work.
   tls-cipher-list=TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256
