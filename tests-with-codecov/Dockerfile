FROM gcr.io/cloud-builders/go:debian-1.18

ARG CODECOV_VERSION=latest
RUN curl https://keybase.io/codecovsecurity/pgp_keys.asc | gpg --import # One-time step
RUN curl -Os https://uploader.codecov.io/${CODECOV_VERSION}/linux/codecov.SHA256SUM.sig && \
    curl -Os https://uploader.codecov.io/${CODECOV_VERSION}/linux/codecov.SHA256SUM && \
    gpg --verify codecov.SHA256SUM.sig codecov.SHA256SUM && \
    curl -fLso codecov https://uploader.codecov.io/${CODECOV_VERSION}/linux/codecov && \
    cat codecov.SHA256SUM | grep codecov | shasum -a 256 -c
RUN chmod +x codecov

# Copy all scripts used for code testing to the image
COPY --chown=root * /scripts/
RUN cp codecov /scripts/codecov
RUN chmod +rwx -R /scripts

# Setup go for shared folders (do not depend on local install)
ENV GOPATH=/go

ENTRYPOINT ["/scripts/execute-unit-tests.sh"]