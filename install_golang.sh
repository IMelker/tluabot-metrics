#!/bin/bash

GO_VERSION=1.16.4

# preinstall golang
mkdir golang && cd golang
wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
#remove old go and unpack new
rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz

# add go to PATH for current session
export PATH=$PATH:/usr/local/go/bin

# check go version
go version