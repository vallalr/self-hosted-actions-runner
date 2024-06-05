FROM ubuntu:latest

ARG RUNNER_VERSION
ENV RUNNER_VERSION=${RUNNER_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    libicu-dev \
    netcat-openbsd

WORKDIR /gh-runner

RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L \
            https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

COPY entrypoint.sh .

RUN useradd --no-create-home --uid 1001 ghrunner
RUN chown -R ghrunner:ghrunner /gh-runner

USER ghrunner

EXPOSE 3000
ENTRYPOINT ["/gh-runner/entrypoint.sh"]