#!/bin/bash
# Arg 1: name of the network to use (chain-simulator, testnet, devnet)
set -e

if [ "$1" == "chain-simulator" ]; then
    scene="mxops_scenes/02b_chain_simulator_faucet.yaml"
else
    scene="mxops_scenes/02a_r3d4_faucet.yaml"
fi

mxops \
    execute \
    -n $1 \
    -s mx-winter-coding-challenge \
    mxops_scenes/01_wallets_creation.yaml \
    $scene \