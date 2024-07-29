FROM ubuntu:20.04

LABEL maintainer="Cas van Cooten"

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# Set timezone to India
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Copy necessary files
COPY setup.sh /root
COPY BugBountyScanner.sh /root
COPY utils /root/utils
COPY dist /root/dist
COPY .env.example /root

# Set Go environment variables
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV PATH=$PATH:/root/go/bin:/usr/local/go/bin
ENV GO111MODULE=on

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    amass \
    httpx \
    nmap \
    golang \
    nuclei \
    subjack \
    jq \
    python3 \
    python3-pip \
    ffuf \
    && apt-get clean

# Install GoSpider
RUN go get -u github.com/jaeles-project/gospider

# Set Go path
ENV PATH=$PATH:/root/go/bin

# Make script executable
RUN chmod +x /root/BugBountyScanner.sh /root/setup.sh

# Run setup script
RUN /root/setup.sh

# Clean up setup script
RUN rm /root/setup.sh

# Run the command on container startup
CMD ["/bin/bash"]
