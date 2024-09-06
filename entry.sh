#!/bin/bash
ARGO_AUTH='eyJhIjoiNTA2NTRiYzBiYTc4NmJlZWM4YjkxMTNjNTE3OWJhNzgiLCJ0IjoiZWU4NmMyM2EtZWViOC00N2E3LTg4M2YtODE3MTRmNDcyNDNiIiwicyI6Ik1tRTVZVGd4TnpndFltUm1NUzAwT0dJMkxUZ3pabVl0WVdNeVpqTTFNRGhoWkdWaSJ9'

generate_web() {
  cat > psweb.sh << EOF
#!/usr/bin/env bash

check_file() {
  [ ! -e psweb ] && wget -O psweb https://github.com/eooce/test/releases/download/amd64/web
}

run() {
  chmod +x psweb && ./psweb -c ./config.json >/dev/null 2>&1 &
}

check_file
run
EOF
}

generate_argo() {
  cat > psargo.sh << ABC
#!/usr/bin/env bash

ARGO_AUTH=${ARGO_AUTH}

check_file() {
  [ ! -e cloud ] && wget -O cloud https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
}

run() {
  chmod +x cloud && ./cloud tunnel --edge-ip-version auto run --token ${ARGO_AUTH} 2>&1 &
}

check_file
run
ABC
}

generate_web
generate_argo
[ -e psweb.sh ] && nohup bash psweb.sh >/dev/null 2>&1 &
[ -e psargo.sh ] && nohup bash psargo.sh >/dev/null 2>&1 &
