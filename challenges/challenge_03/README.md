# Challenge 3

Official description of the challenge: https://multiversx.notion.site/5-December-15173522fb4d80469fdbe28535de5ec2

## Objectives

For each of the tokens created during challenge #02, we want to transfer 10,000 units to 1,000 other accounts.

## Tutorial

### Dependencies

This challenge will use the develop [MxOps](https://github.com/Catenscia/MxOps) version `3.0.0.dev16`, be sure to have it updated.

```bash
pipx install git+https://github.com/Catenscia/MxOps@develop --force
```

For this challenge #03, the following feature has been specifically added to MxOps:

- wait step: [MxOps PR#92](https://github.com/Catenscia/MxOps/pull/92)


### Steps

### Some little maths

In total, we want to make 9000 transactions and for simplicity, all the tokens will be sent by their respective owners. We know that a given wallet cannot have more than 100 transactions in the transaction pool ([source](https://docs.multiversx.com/integrators/creating-transactions/#issue-too-many-transactions-from-the-same-account)).
If we take half of that for a security margin, this would make batches of 50 transactions per tokens owners, so a total of 450 transactions per batch.

The transfer of 10,000 WINTER-* tokens consumes 325,000 gas. The gas capacity of a block being 3,000,000,000, this would make 9230 WINTER-* admissible transfers per block, so we can safely assume that the 450 transactions of each batch will be ingested in a single block time by the devnet. (In reality, our tokens owners are on three seperate shards and there will be some cross-shard transactions but the there is no need to over complexify the calculation as we have a very good margin)

Given the above information, this will be our plan:

- generate 50 random addresses
- make each of the token owners send each of them 10,000 WINTER-* tokens
- wait for the next block
- repeat 20 times

The 9000 transactions should be confirmed in about 4/5 minutes, which is acceptable for this tutorial. (Depending on your internet connection, there is a chance that it will take a longer that that, as we will be sending the transactions one by one)


```{info}
This process could obviously be made in a much more fault tolerant and optimized manner, but for the sake of the tutorial, we will keep things simple.
```

### Generating random addresses

MxOps already has a function to generate new wallets, so we are gonna use it as our random address generator.

Let's create a python module [functions.py](./scripts/functions.py), with a function to generate random addresses:

```python
from typing import List

from mxops.utils.wallets import generate_pem_wallet


def generate_random_addresses(n: int) -> List[str]:
    """
    Generate random addresses for the MultiversX network and return them

    :param n: num of addresses to generate
    :type n: int
    :return: generated addresses
    :rtype: List[str]
    """
    addresses = []
    for _ in range(n):
        _, address = generate_pem_wallet()
        addresses.append(address.to_bech32())
    return addresses
```

This function simply generate as many addresses as wanted and return them under their bech32 format.

To use this function within MxOps, we are going to write a [Python Step](https://mxops.readthedocs.io/en/latest/user_documentation/steps.html#python-step).

```yaml
type: Python
module_path: ./scripts/functions.py
function: generate_random_addresses
arguments:
    - "%batch_size"
print_result: false
result_save_key: random_receivers
```

This step tells MxOps to call the python function we created and to save the generated addresses in the variable named `random_receivers`. You can notice that the argument provided to the python function is not a number, it is a reference to a variable name `batch_size`. This is just to showcase that you can supply variables to your custom python function. We will define `batch_size` a bit later (with a value of 50).

### Transfers

To transfers the tokens, we will operate a nested loop: the first one will loop over the random receivers while the second one will loop over the token owners.

```yaml
- type: Loop
    var_name: receiver
    var_list: "%random_receivers"
    steps:
      - type: Loop
        var_name: user
        var_list: "%user_accounts"
        steps:
          - type: FungibleTransfer
            sender: "%user"
            receiver: "%receiver"
            token_identifier: "%{%{user}WinterToken.identifier}"
            amount: 10_000_00000000
            checks: []
```

To correctly define each transfer, we are using the [variable composition](https://mxops.readthedocs.io/en/latest/user_documentation/values.html#composability) of MxOps:
- the sender is written as "%user" which will be evaluated as a user from the loaded user accounts (alice, bob, ...)
- the sender is written as "%receiver", which will be evaluated as a random address from the generated random receivers
- the token identifier is build in two times. First we are constructing the name of the token, using the name of the user (bob -> bobWinterToken), and then we are taking the identifier if this token (bobWinterToken.identifier).

An important detail is that we have specified that the FungibleTransfer step should have no check: this means that MxOps will not verify the status of the transfer (fail or success). If we were to check each transation, this challenge would take much more time. Instead, we are just gonna manually check at the end that each token has 1001 holders (1000 random accounts + the owner of the token).

### Scenes

To keep things clean, we will create two scenes to exploit the elements defined above.

The first scene, called [batch_send.yaml](./mxops_scenes/sub_scenes/batch_send.yaml), will focus on operating the sending of the batch of 450 transactions by using the python step and the transfer step mentionned above. This is what we call a sub-scene or a parameterized scene: it is not intendend to be directly run on its own, but rather be called by another scene, which we will define just after. In our case, it is because our sub-scene has the parameters "batch_size" and "user_accounts" which are not defined yet. You can almost see this sub-scene as a function with parameters.

```yaml
allowed_networks:
    - testnet
    - devnet
    - chain-simulator

allowed_scenario:
    - "mx-winter-coding-challenge"

steps:

  - type: Python
    module_path: ./scripts/functions.py
    function: generate_random_addresses
    arguments:
      - "%batch_size"
    print_result: false
    result_save_key: random_receivers

  
  - type: Loop
    var_name: receiver
    var_list: "%random_receivers"
    steps:
      - type: Loop
        var_name: user
        var_list: "%user_accounts"
        steps:
          - type: FungibleTransfer
            sender: "%user"
            receiver: "%receiver"
            token_identifier: "%{%{user}WinterToken.identifier}"
            amount: 10_000_00000000
            checks: []
```

The second one will focus on initially loading the user accounts, setting the batch size, calling the batch scene and waiting between the batches.

let's call this scene [01_airdrops.yaml](./mxops_scenes/01_airdrops.yaml)

```yaml
allowed_networks:
    - testnet
    - devnet
    - chain-simulator

allowed_scenario:
    - "mx-winter-coding-challenge"

accounts:
  - name: user_accounts
    folder_path: ./../../wallets

steps:

  - type: SetVars
    variables:
      batch_size: 50
  
  - type: Loop
    var_name: LoopVar
    var_start: 0
    var_end: 20
    steps:
      - type: Scene
        scene_path: ./mxops_scenes/sub_scenes/batch_send.yaml
      - type: Wait
        for_blocks: 1

  - type: Wait
    for_blocks: 3
```

## Run and Results

To run the challenge on the devnet, a single command is needed. We will call MxOps and provided the airdrop scene:

```bash
mxops \
    execute \
    -n devnet \
    -s mx-winter-coding-challenge \
    mxops_scenes/01_airdrops.yaml
```

This will execute 9000 transactions on the devnet. You can check that each token has more than 1000 holders:

- [WINTER-0cb519](https://devnet-explorer.multiversx.com/tokens/WINTER-0cb519)
- [WINTER-5202af](https://devnet-explorer.multiversx.com/tokens/WINTER-5202af)
- [WINTER-d5f118](https://devnet-explorer.multiversx.com/tokens/WINTER-d5f118)
- [WINTER-8f8ef0](https://devnet-explorer.multiversx.com/tokens/WINTER-8f8ef0)
- [WINTER-14e07f](https://devnet-explorer.multiversx.com/tokens/WINTER-14e07f)
- [WINTER-1c20e4](https://devnet-explorer.multiversx.com/tokens/WINTER-1c20e4)
- [WINTER-bd84e0](https://devnet-explorer.multiversx.com/tokens/WINTER-bd84e0)
- [WINTER-9cdc40](https://devnet-explorer.multiversx.com/tokens/WINTER-9cdc40)
- [WINTER-4d86e1](https://devnet-explorer.multiversx.com/tokens/WINTER-4d86e1)

That's it for the third challenge! Don't hesitate to clone this [repo](https://github.com/EtienneWallet/MultiversXWinterCodingChallenge2024) and execute it on your computer to familiarise yourself with MxOps 😊