# test-pqc

Tests OpenSSL 3.5 TLS hybrid (post-quantum/classical) key agreement schemes with nginx 1.28.0:

```
    ssl_protocols TLSv1.3;
    ssl_conf_command Groups X25519MLKEM768:SecP384r1MLKEM1024:SecP256r1MLKEM768:MLKEM1024:X25519:secp384r1;
    ssl_conf_command Options +ServerPreference;
    ssl_conf_command Options +PrioritizeChaCha;
    ssl_conf_command Ciphersuites TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384;
```

Results

Enter domain to test (e.g. example.com): yawnbox.eu

Target : yawnbox.eu
Server : nginx
OpenSSL: 3.5.1 1 Jul 2025 (Library: OpenSSL 3.5.1 1 Jul 2025)

Key        TLS      Group                                  Cipher                              Res 
───────────────────────────────────────────────────────────────────────────────────────────────────
RSA(4096)  TLSv1.3  SecP384r1MLKEM1024                     TLS_AES_256_GCM_SHA384              OK
RSA(4096)  TLSv1.3  SecP384r1MLKEM1024                     TLS_CHACHA20_POLY1305_SHA256        OK
RSA(4096)  TLSv1.3  SecP384r1MLKEM1024                     TLS_AES_128_GCM_SHA256              OK
RSA(4096)  TLSv1.3  SecP256r1MLKEM768                      TLS_AES_256_GCM_SHA384              OK
RSA(4096)  TLSv1.3  SecP256r1MLKEM768                      TLS_CHACHA20_POLY1305_SHA256        OK
RSA(4096)  TLSv1.3  SecP256r1MLKEM768                      TLS_AES_128_GCM_SHA256              OK
RSA(4096)  TLSv1.3  X25519MLKEM768                         TLS_AES_256_GCM_SHA384              OK
RSA(4096)  TLSv1.3  X25519MLKEM768                         TLS_CHACHA20_POLY1305_SHA256        OK
RSA(4096)  TLSv1.3  X25519MLKEM768                         TLS_AES_128_GCM_SHA256              OK
RSA(4096)  TLSv1.3  MLKEM1024                              TLS_AES_256_GCM_SHA384              OK
RSA(4096)  TLSv1.3  MLKEM1024                              TLS_CHACHA20_POLY1305_SHA256        OK
RSA(4096)  TLSv1.3  MLKEM1024                              TLS_AES_128_GCM_SHA256              OK
RSA(4096)  FAIL     MLKEM768                               TLS_AES_256_GCM_SHA384              FAIL
RSA(4096)  FAIL     MLKEM768                               TLS_CHACHA20_POLY1305_SHA256        FAIL
RSA(4096)  FAIL     MLKEM768                               TLS_AES_128_GCM_SHA256              FAIL
RSA(4096)  FAIL     MLKEM512                               TLS_AES_256_GCM_SHA384              FAIL
RSA(4096)  FAIL     MLKEM512                               TLS_CHACHA20_POLY1305_SHA256        FAIL
RSA(4096)  FAIL     MLKEM512                               TLS_AES_128_GCM_SHA256              FAIL
RSA(4096)  FAIL     X448MLKEM1024                          TLS_AES_256_GCM_SHA384              FAIL
RSA(4096)  FAIL     X448MLKEM1024                          TLS_CHACHA20_POLY1305_SHA256        FAIL
RSA(4096)  FAIL     X448MLKEM1024                          TLS_AES_128_GCM_SHA256              FAIL
```
