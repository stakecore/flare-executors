FROM ghcr.io/foundry-rs/foundry

WORKDIR /app
COPY . .

RUN apt-get update
RUN apt-get install bc jq curl