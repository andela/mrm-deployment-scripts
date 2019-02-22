FROM google/cloud-sdk

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y  \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common

RUN apt-get install -y unzip wget && \
        wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip && \
        unzip terraform_0.11.10_linux_amd64.zip && \
        mv terraform /usr/local/bin/

RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v1.8.7/bin/linux/amd64/kubectl && \
        chmod +x kubectl && \
        mv kubectl /usr/bin

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - 

RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" && \
        apt-get update && apt-get install docker-ce -y
