#!/bin/bash
# Arg 1: name of the network to use (chain-simulator, testnet, devnet)
set -e

mxops \
    execute \
    -n $1 \
    -s mx-winter-coding-challenge \
    mxops_scenes/01_airdrops.yaml