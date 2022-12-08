ARG PROJECT_ID
FROM gcr.io/${PROJECT_ID}/kritis-signer as kritis 

# We just want access to the innards of the image, copy what we need.
FROM gcr.io/cloud-builders/gcloud:latest as runtime

COPY --from=kritis /kritis/signer /kritis/signer

COPY sign-image.sh .
RUN chmod +x sign-image.sh 

ENTRYPOINT ["bash"]
CMD ["/sign-image.sh"]
