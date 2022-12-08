# CI Image Signing

This builder is used to check vulnz policy for CI images.

## Usage

In cloudbuild.yaml, put the following step after an image was pushed.

```yaml
- name: 'gcr.io/$PROJECT_ID/cloud-builders/ci-image-signer'
  env:
    - "DIGEST_FILENAME=image-digest.txt"
    - "VULNZ_CHECK_POLICY=.cloudbuild/docker/vulnerability_scan_policy.yaml"
```

## Environment Variables

`DIGEST_FILENAME` is the filename to be used to get the details on image to sign
`VULNZ_CHECK_POLICY` is the full path to the policy file to use to perform vulnerability check
