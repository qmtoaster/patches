Spamdyke TLS v1.3 patch

Running spamdyke >= 5.0.1-3 on RHEL 8 and variants one should add the following line to spamdyke.conf if it is not already configured:
      tls-cipher-list=TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256
