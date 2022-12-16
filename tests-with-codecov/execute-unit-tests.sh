#!/bin/bash
set -euo pipefail;

set +u; # prevent script from exploding if BUILDER_OUTPUT is undefined

if [ -n "${BUILDER_OUTPUT}" ] && [ -z "${BRANCH_NAME}" ]; then
    echo "CI environment detected, but BRANCH_NAME empty, specify BRANCH_NAME, COMMIT_SHA, and CODECOV_TOKEN to upload coverage reports as part of CI build."
    exit 1;
fi

if [ -n "${BUILDER_OUTPUT}" ] && [ -z "${COMMIT_SHA}" ]; then
    echo "CI environment detected, but COMMIT_SHA empty, specify BRANCH_NAME, COMMIT_SHA, and CODECOV_TOKEN to upload coverage reports as part of CI build."
    exit 1;
fi

if [ -n "${BUILDER_OUTPUT}" ] && [ -z "${CODECOV_TOKEN}" ]; then
    echo "CI environment detected, but CODECOV_TOKEN empty, specify BRANCH_NAME, COMMIT_SHA, and CODECOV_TOKEN to upload coverage reports as part of CI build."
    exit 1;
fi

echo "Removing any lingering coverage reports"
mkdir -p /workspace/.coverage/unit
rm -f /workspace/.coverage/unit/*

echo "Launching unit tests"
go test ./... -race -coverpkg=./... -coverprofile=/workspace/.coverage/unit/tests.cov;

if [ -z "${BUILDER_OUTPUT}" ]; then
    echo "CI environment NOT detected. Skipping codecov unit test report uploading."
else
    echo "CI environment detected. Uploading unit test coverage to codecov"
    /scripts/codecov -t ${CODECOV_TOKEN} -f /workspace/.coverage/unit/tests.cov -X gcov -F unit -B ${BRANCH_NAME} -C ${COMMIT_SHA}
fi

set -u; # restore undefined variable check

