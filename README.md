# test-pqc

Tests openssl 3.5 post-quantum cryptography (client and server version) with nginx 1.28.0 example config:

```
    ssl_protocols TLSv1.3;
    ssl_conf_command Groups X25519MLKEM768:SecP384r1MLKEM1024:SecP256r1MLKEM768:MLKEM1024:X25519:secp384r1;
    ssl_conf_command Options +ServerPreference;
    ssl_conf_command Options +PrioritizeChaCha;
    ssl_conf_command Ciphersuites TLS_AEGIS_128L_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384;
```

Results

```
Enter domain to test (e.g. example.com): cyber.cafe

Target : cyber.cafe
Server : nginx
OpenSSL: 3.5.0 8 Apr 2025 (Library: OpenSSL 3.5.0 8 Apr 2025)

Key        TLS      Group                                  Cipher                              Res 
───────────────────────────────────────────────────────────────────────────────────────────────────
RSA(4096)  TLSv1.3  SecP384r1MLKEM1024                     TLS_AES_256_GCM_SHA384              OK
RSA(4096)  TLSv1.3  SecP384r1MLKEM1024                     TLS_CHACHA20_POLY1305_SHA256        OK
RSA(4096)  FAIL     SecP384r1MLKEM1024                     TLS_AES_128_GCM_SHA256              FAIL
RSA(4096)  TLSv1.3  SecP256r1MLKEM768                      TLS_AES_256_GCM_SHA384              OK
RSA(4096)  TLSv1.3  SecP256r1MLKEM768                      TLS_CHACHA20_POLY1305_SHA256        OK
RSA(4096)  FAIL     SecP256r1MLKEM768                      TLS_AES_128_GCM_SHA256              FAIL
RSA(4096)  TLSv1.3  X25519MLKEM768                         TLS_AES_256_GCM_SHA384              OK
RSA(4096)  TLSv1.3  X25519MLKEM768                         TLS_CHACHA20_POLY1305_SHA256        OK
RSA(4096)  FAIL     X25519MLKEM768                         TLS_AES_128_GCM_SHA256              FAIL
RSA(4096)  TLSv1.3  MLKEM1024                              TLS_AES_256_GCM_SHA384              OK
RSA(4096)  TLSv1.3  MLKEM1024                              TLS_CHACHA20_POLY1305_SHA256        OK
RSA(4096)  FAIL     MLKEM1024                              TLS_AES_128_GCM_SHA256              FAIL
RSA(4096)  FAIL     MLKEM768                               TLS_AES_256_GCM_SHA384              FAIL
RSA(4096)  FAIL     MLKEM768                               TLS_CHACHA20_POLY1305_SHA256        FAIL
RSA(4096)  FAIL     MLKEM768                               TLS_AES_128_GCM_SHA256              FAIL
RSA(4096)  FAIL     MLKEM512                               TLS_AES_256_GCM_SHA384              FAIL
RSA(4096)  FAIL     MLKEM512                               TLS_CHACHA20_POLY1305_SHA256        FAIL
RSA(4096)  FAIL     MLKEM512                               TLS_AES_128_GCM_SHA256              FAIL

Summary: 8 OK, 10 FAIL  (timeout=3s)
```
