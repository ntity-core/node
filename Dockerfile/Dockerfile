# Image definition
FROM golang:1.16-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

WORKDIR /

RUN git clone https://github.com/ethereum/go-ethereum.git && cd ./go-ethereum && git checkout tags/v1.10.11 && make all

FROM alpine:latest

RUN apk add --no-cache ca-certificates bash nodejs npm perl git
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/
COPY --from=builder /go-ethereum/build/bin/puppeth /usr/local/bin/

RUN cd /root &&\
    git clone https://github.com/cubedro/eth-net-intelligence-api &&\
    cd eth-net-intelligence-api &&\
    npm install &&\
    npm install -g pm2

# Shell script
COPY ./Dockerfile/run.sh /root/run.sh
RUN chmod +x /root/*.sh

# Misc
EXPOSE 8545 8546 30303 30303/udp
CMD ["/root/run.sh"]

