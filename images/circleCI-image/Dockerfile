FROM debian:latest

RUN apt-get update && apt-get -y install \
  curl gnupg2 lsb-release wget \
  git ssh tar gzip ca-certificates \
  software-properties-common python-pip python-yaml python3-pip jq

RUN pip install cloudflare && pip3 install pyyaml


# Install Gcloud
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
  echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  apt-get update && apt-get -y install google-cloud-sdk kubectl

RUN update-ca-certificates

RUN curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh

CMD ["gcloud"]
