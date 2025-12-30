#!/bin/sh

# Sync ca certificates
/var/apps/mono/target/bin/cert-sync /etc/ssl/certs/ca-certificates.crt
