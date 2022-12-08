#!/bin/bash
set -euo pipefail

set +u; #relax unbound variable check for this part
if [ ! -z "${DEBUG}" ]; then
  echo "DEBUG switch specified, printing current gcloud config"
  gcloud config list --all
fi
set -u;

# Check that the vulnerability check policy passes (no signature)
/kritis/signer \
    -v=10 \
    -alsologtostderr \
    -mode=check-only \
    -image=$(/bin/cat $DIGEST_FILENAME) \
    -policy=${VULNZ_CHECK_POLICY} 
