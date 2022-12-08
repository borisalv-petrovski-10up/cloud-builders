# CI Image Signing

This builder is used to check vulnz policy and sign CI images. It adds a signature depending on the branch it's on.

## Usage (cloud build)

In cloudbuild.yaml, put the following step after an image was pushed.

```yaml
- name: 'gcr.io/$PROJECT_ID/cloud-builders/ci-image-signer'
  env:
    - "BRANCH_NAME=$BRANCH_NAME"
    - "DIGEST_FILENAME=image-digest.txt"
    - "VULNZ_CHECK_POLICY=.cloudbuild/docker/vulnerability_scan_policy.yaml"
    - "KMS_DIGEST_ALGORITHM=${_KMS_DIGEST_ALGORITHM}"
    - "KMS_KEY_NAME=${_KMS_KEY_NAME_IMAGE_BUILT_ON_MASTER}"
    - "ATTESTOR_NAME=${_ATTESTOR_IMAGE_BUILT_ON_MASTER}"
```

## Environment Variables

`BRANCH_NAME` is injected automatically by google cloud build. Used to determine if official version or not.
`DIGEST_FILENAME` is the filename to be used to get the details on image to sign
`KMS_DIGEST_ALGORITHM` is the KMS key algorithm used.
`VULNZ_CHECK_POLICY` is the full path to the policy file to use to perform vulnerability check before attesting.
`KMS_KEY_NAME` is the KMS key name for the attestation that image comes from master branch.
`ATTESTOR_NAME` is the name of the attestor to use to apply attestation.

## Outcome

Signature(s) will be added to image metadata.
