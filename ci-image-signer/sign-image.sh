#!/bin/bash
set -euo pipefail

set +u; #relax unbound variable check for this part
if [ ! -z "${DEBUG}" ]; then
  echo "DEBUG switch specified, printing current gcloud config"
  gcloud config list --all
fi
set -u;

#Check that the vulnerability check policy passes (no signature)
/kritis/signer \
    -v=10 \
    -alsologtostderr \
    -mode=check-only \
    -image=$(/bin/cat $DIGEST_FILENAME) \
    -policy=${VULNZ_CHECK_POLICY} 

if [[ "${BRANCH_NAME}" = "main" ]]; then
    echo "Signing image with the '${ATTESTOR_NAME}' binauthz attestor.";

    set +u;
    if [ ! -z "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then
        echo "Activating service account from ${GOOGLE_APPLICATION_CREDENTIALS}";
        gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS};
    fi
    set -u;

    gcloud beta container binauthz attestations sign-and-create \
    --artifact-url="$(/bin/cat $DIGEST_FILENAME)" \
    --attestor="${ATTESTOR_NAME}" \
    --keyversion="${KMS_KEY_NAME}" \
    --project=${PROJECT_ID}
else
    echo "Not signing the image with binauthz attestor, wrong branch(current branch: ${BRANCH_NAME}).";
fi
