#!/usr/bin/env bash
# post‑quantum handshake test matrix
set -uo pipefail

# ── ask user for the target domain ───────────────────────────────────────
read -rp "Enter domain to test (e.g. example.com): " TARGET
PORT=443
TIMEOUT=3

# ── banner ───────────────────────────────────────────────────────────────
SERVER_HDR=$(curl -sIm1 "https://$TARGET" | grep -i '^Server:' | cut -d' ' -f2-)
echo -e "\nTarget : $TARGET"
echo "Server : ${SERVER_HDR:-unknown}"
echo "OpenSSL: $(openssl version | cut -d' ' -f2-)"
echo

# ── leaf‑certificate key info ────────────────────────────────────────────
CERT=$(openssl s_client -connect "$TARGET:$PORT" -servername "$TARGET" \
         -showcerts </dev/null 2>/dev/null | openssl x509 -noout -text)

BITS=$(grep -m1 'Public-Key:' <<<"$CERT" | tr -dc '0-9')
[[ $CERT =~ id-ecPublicKey ]] && KEY="EC(${BITS})" || KEY="RSA(${BITS})"

# ── PQ / hybrid test matrix ──────────────────────────────────────────────
TESTS=(
  'SecP384r1MLKEM1024|TLS_AES_256_GCM_SHA384'
  'SecP384r1MLKEM1024|TLS_CHACHA20_POLY1305_SHA256'
  'SecP384r1MLKEM1024|TLS_AES_128_GCM_SHA256'
  'SecP384r1MLKEM1024|TLS_AEGIS_128X2_SHA256'
  'SecP384r1MLKEM1024|TLS_AEGIS_128L_SHA256'
  'SecP384r1MLKEM1024|TLS_AEGIS_256_SHA512'
  'SecP384r1MLKEM1024|TLS_AEGIS_256X2_SHA512'

  'SecP256r1MLKEM768|TLS_AES_256_GCM_SHA384'
  'SecP256r1MLKEM768|TLS_CHACHA20_POLY1305_SHA256'
  'SecP256r1MLKEM768|TLS_AES_128_GCM_SHA256'
  'SecP256r1MLKEM768|TLS_AEGIS_128X2_SHA256'
  'SecP256r1MLKEM768|TLS_AEGIS_128L_SHA256'
  'SecP256r1MLKEM768|TLS_AEGIS_256_SHA512'
  'SecP256r1MLKEM768|TLS_AEGIS_256X2_SHA512'

  'X25519MLKEM768|TLS_AES_256_GCM_SHA384'
  'X25519MLKEM768|TLS_CHACHA20_POLY1305_SHA256'
  'X25519MLKEM768|TLS_AES_128_GCM_SHA256'
  'X25519MLKEM768|TLS_AEGIS_128X2_SHA256'
  'X25519MLKEM768|TLS_AEGIS_128L_SHA256'
  'X25519MLKEM768|TLS_AEGIS_256_SHA512'
  'X25519MLKEM768|TLS_AEGIS_256X2_SHA512'

  'MLKEM1024|TLS_AES_256_GCM_SHA384'
  'MLKEM1024|TLS_CHACHA20_POLY1305_SHA256'
  'MLKEM1024|TLS_AES_128_GCM_SHA256'
  'MLKEM1024|TLS_AEGIS_128X2_SHA256'
  'MLKEM1024|TLS_AEGIS_128L_SHA256'
  'MLKEM1024|TLS_AEGIS_256_SHA512'
  'MLKEM1024|TLS_AEGIS_256X2_SHA512'

  'MLKEM768|TLS_AES_256_GCM_SHA384'
  'MLKEM768|TLS_CHACHA20_POLY1305_SHA256'
  'MLKEM768|TLS_AES_128_GCM_SHA256'
  'MLKEM768|TLS_AEGIS_128X2_SHA256'
  'MLKEM768|TLS_AEGIS_128L_SHA256'
  'MLKEM768|TLS_AEGIS_256_SHA512'
  'MLKEM768|TLS_AEGIS_256X2_SHA512'

  'MLKEM512|TLS_AES_256_GCM_SHA384'
  'MLKEM512|TLS_CHACHA20_POLY1305_SHA256'
  'MLKEM512|TLS_AES_128_GCM_SHA256'
  'MLKEM512|TLS_AEGIS_128X2_SHA256'
  'MLKEM512|TLS_AEGIS_128L_SHA256'
  'MLKEM512|TLS_AEGIS_256_SHA512'
  'MLKEM512|TLS_AEGIS_256X2_SHA512'

  'X448MLKEM1024|TLS_AES_256_GCM_SHA384'
  'X448MLKEM1024|TLS_CHACHA20_POLY1305_SHA256'
  'X448MLKEM1024|TLS_AES_128_GCM_SHA256'
  'X448MLKEM1024|TLS_AEGIS_128X2_SHA256'
  'X448MLKEM1024|TLS_AEGIS_128L_SHA256'
  'X448MLKEM1024|TLS_AEGIS_256_SHA512'
  'X448MLKEM1024|TLS_AEGIS_256X2_SHA512'
)

# ── header ───────────────────────────────────────────────────────────────
printf '%-10s %-8s %-38s %-35s %-4s\n' "Key" "TLS" "Group" "Cipher" "Res"
printf '─%.0s' {1..99}; echo

OK=0 FAIL=0
for entry in "${TESTS[@]}"; do
  IFS='|' read -r GROUP CIPHER <<<"$entry"

  RAW=$(timeout "${TIMEOUT}s" openssl s_client -quiet -ign_eof \
          </dev/null -connect "$TARGET:$PORT" -tls1_3 \
          -groups "$GROUP" -ciphersuites "$CIPHER" \
          -servername "$TARGET" -brief 2>&1 || true)

  TLS=$(grep -m1 'Protocol version' <<<"$RAW" | awk '{print $3}' || true)

  if [[ $TLS == TLSv1.3 ]]; then
      TLSCOL=$(printf '%-8s' "$TLS")
      RESCOL="\e[32mOK\e[0m"; ((OK++))
  else
      TLSCOL=$(printf '\e[31m%-8s\e[0m' 'FAIL')
      RESCOL="\e[31mFAIL\e[0m"; ((FAIL++))
  fi

  printf '%-10s %b %-38s %-35s %b\n' "$KEY" "$TLSCOL" "$GROUP" "$CIPHER" "$RESCOL"
done

printf '\nSummary: \e[32m%d OK\e[0m, \e[31m%d FAIL\e[0m  (timeout=%ss)\n' \
        "$OK" "$FAIL" "$TIMEOUT"


