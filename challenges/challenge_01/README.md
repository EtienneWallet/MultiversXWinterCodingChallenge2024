# Challenge 1

Official description of the challenge: https://multiversx.notion.site/3-December-15073522fb4d810cb5eef921ce9d2217

## Objectives

The first objective here is to generate three new accounts in each of the MultiversX shards (at the moment, MultiversX has three shards, excluding the meta chain).
Then, we must request tokens from a faucet for each of these wallets, so that the have the necessary funds to interact with the blockchain

## Tutorial

### Dependencies

This challenge will use the develop [MxOps](https://github.com/Catenscia/MxOps) version `3.0.0.dev13`, be sure to have it updated.

```bash
pipx install git+https://github.com/Catenscia/MxOps@develop --force
```

### Steps

#### Accounts Creation

To create an account, will simply use the step called [`GenerateWallet`](https://mxops.readthedocs.io/en/latest/user_documentation/steps.html#generate-wallets-step) from MxOps.

The step looks like this

```yaml
type: GenerateWallets
save_folder: ./../../wallets  # folder where to save the generated wallets
wallets:
    - alice
    - bob
    - chalie
shard: 0
```

This will create three pem wallets on the shard 0, name them "alice", "bob" and "charlie" and save them in the [wallets folder](./../../wallets).

Let's create a scene called [01_wallets_creation.yaml](./mxops_scenes/01_wallets_creation.yaml).

```yaml
allowed_networks:
    - testnet
    - devnet
    - chain-simulator

allowed_scenario:
    - "mx-winter-coding-challenge"

steps:
  - type: GenerateWallets
    save_folder: ./../../wallets
    wallets:
        - alice
        - bob
        - chalie
    shard: 0

  - type: GenerateWallets
    save_folder: ./../../wallets
    wallets:
        - diana
        - eve
        - franck
    shard: 1

  - type: GenerateWallets
    save_folder: ./../../wallets
    wallets:
        - grace
        - hank
        - jack
    shard: 2

```

This scenes will create 9 wallets, 3 on each shards.

#### Faucet

To automatically fund the newly created wallets, we will use the [r3d4 faucet](https://r3d4.fr/faucet). Each new wallet will receive 1 EGLD.

So let's create the file [02a_r3d4_faucet.yaml](./mxops_scenes/02a_r3d4_faucet.yaml):
```yaml
allowed_networks:  # the r3d4 faucet only works on testnet and devnet
    - testnet
    - devnet

allowed_scenario:
    - "mx-winter-coding-challenge"

accounts:
  # load all the accounts by their names (ex: bob, alice, ...)
  - name: user_accounts
    folder_path: ./../../wallets

steps:
  - type: R3D4Faucet
    targets: "%user_accounts"

```

Let's break it into two parts:


##### 1. Account loading

```yaml
accounts:
  # load all the accounts by their names (ex: bob, alice, ...)
  - name: user_accounts
    folder_path: ./../../wallets
```

The first thing happening is the loading of all the previously created wallets. As each wallet already has a name (ex alice.pem), we will simply load the entire folder and MxOps will use the name of the file as account ids. This will enable us to simply write 'alice' and MxOps will know that it references to the account of the file alice.pem located in the wallets folder.
All the loaded accounts will be written in a Scenario variable called `user_accounts`, so that we can reference all accounts at once.

##### 2. Faucet calls

```yaml
steps:
  - type: R3D4Faucet
    targets: "%user_accounts"
```

This tells MxOps to use the r3d4 faucet on all of the accounts referenced in the Scenario variable `user_accounts` that was created when loading all the wallets. This avoid us the pain of writing by hand all the accounts name 😊.

```{warning}
❗The r3d4 faucet is often emptied of EGLD on the devnet, so you may want to use the testnet or manually use the faucet on the [webwallet](https://devnet-wallet.multiversx.com/).
```


💡 For the chain-simulator equivalent, a scene name [02b_chain_simulator_faucet.yaml](./mxops_scenes/02b_chain_simulator_faucet.yaml) with the step [`ChainSimulatorFaucet`](https://mxops.readthedocs.io/en/latest/user_documentation/steps.html#chain-simulator-faucet-step) was created.


That's it for preparation, now we only have to execute everything!

## Run and Results

To execute MxOps, we need to specify three main information:

- the network (mainnet, devnet, ...)
- the name of the scenario (dedicated data environment where the variables, addresses and others will be saved)
- the scenes that we want to execute (in our case, the wallets creation scene and the faucet scene)

For all the challenges, we will use the devnet and a shared scenario, so that data can be shared from one challenge to the other. We call this Scenario `mx-winter-coding-challenge`.


📘 For more information on how Scenarios work, please head to the [MxOps documentation](https://mxops.readthedocs.io/en/latest/user_documentation/scenario.html)


To execute our first challenge on the devnet, a single command is needed:

```bash
mxops \
    execute \
    -n devnet \
    -s mx-winter-coding-challenge \
    mxops_scenes/01_wallets_creation.yaml \
    mxops_scenes/02a_r3d4_faucet.yaml \
```

You should have some logs that will look like this

```
MxOps  Copyright (C) 2023  Catenscia 
This program comes with ABSOLUTELY NO WARRANTY
[2024-12-13 06:27:18,010 data INFO] Scenario mx-winter-coding-challenge created for network devnet [execution_data.py:674 in create_scenario]
[2024-12-13 06:27:18,010 scene INFO] Executing scene mxops_scenes/01_wallets_creation.yaml [scene.py:74 in execute_scene]
[2024-12-13 06:27:18,017 steps INFO] Wallet n°1/3 generated with address erd1cnef85j3427z579rjdlelrhjgm96zjfpt0c2hnwhzew0ks74832q3rjnk5 at ../../wallets/alice.pem [steps.py:1764 in execute]
[2024-12-13 06:27:18,021 steps INFO] Wallet n°2/3 generated with address erd163vmy4q7xsm9p8whcvve9sqaftrzv73rcqp2ledhmgrqgpvu6c7q7wtge9 at ../../wallets/bob.pem [steps.py:1764 in execute]
[2024-12-13 06:27:18,038 steps INFO] Wallet n°3/3 generated with address erd1z9jx2w626u6xjv887hv70d7peavk7wunqw8d830lrsp3x0p0k27queg55n at ../../wallets/chalie.pem [steps.py:1764 in execute]
[2024-12-13 06:27:18,048 steps INFO] Wallet n°1/3 generated with address erd1hyqgwux08z8p88exh4vth46as8l4luq9tzk3vpvwac3xcew3wv2suhf827 at ../../wallets/diana.pem [steps.py:1764 in execute]
[2024-12-13 06:27:18,064 steps INFO] Wallet n°2/3 generated with address erd1m8hnjq7fwp6fejs3ycw4g5c03aqr7w4nwk2k4f8s9ng2nler4p7szwu5ec at ../../wallets/eve.pem [steps.py:1764 in execute]
[2024-12-13 06:27:18,075 steps INFO] Wallet n°3/3 generated with address erd1e70m48wpry5ldlm7trq32avwfjhgln62l4dd7u6y3zucr4sk77ks4vmndv at ../../wallets/franck.pem [steps.py:1764 in execute]
[2024-12-13 06:27:18,084 steps INFO] Wallet n°1/3 generated with address erd1ue3plqqqzsvdtexae0fu6p42s7e4nu6qly46sz3y7ggtxe93zc0quf3q2j at ../../wallets/grace.pem [steps.py:1764 in execute]
[2024-12-13 06:27:18,088 steps INFO] Wallet n°2/3 generated with address erd1wcllvmj3frc8t7h48lfpyv2g9nwdjmdeyf3g8px40pvma6vhqvnq4vtmaj at ../../wallets/hank.pem [steps.py:1764 in execute]
[2024-12-13 06:27:18,096 steps INFO] Wallet n°3/3 generated with address erd1vhswl4cxr3zlqmreu2kmxm47amvzhg0e40h0qyn5j7yrajp4xpfq3alkpw at ../../wallets/jack.pem [steps.py:1764 in execute]
[2024-12-13 06:27:18,096 scene INFO] Executing scene mxops_scenes/02b_r3d4_faucet.yaml [scene.py:74 in execute_scene]
[2024-12-13 06:27:19,102 steps INFO] Requesting 1.0 dEGLD from r3d4 faucet for alice (erd1cnef85j3427z579rjdlelrhjgm96zjfpt0c2hnwhzew0ks74832q3rjnk5) [steps.py:1814 in execute]
[2024-12-13 06:27:19,194 steps INFO] Response from faucet: Added to list [steps.py:1851 in request_faucet]
[2024-12-13 06:27:19,196 steps INFO] Requesting 1.0 dEGLD from r3d4 faucet for bob (erd163vmy4q7xsm9p8whcvve9sqaftrzv73rcqp2ledhmgrqgpvu6c7q7wtge9) [steps.py:1814 in execute]
[2024-12-13 06:27:19,278 steps INFO] Response from faucet: Added to list [steps.py:1851 in request_faucet]
[2024-12-13 06:27:19,280 steps INFO] Requesting 1.0 dEGLD from r3d4 faucet for charlie (erd1z9jx2w626u6xjv887hv70d7peavk7wunqw8d830lrsp3x0p0k27queg55n) [steps.py:1814 in execute]
[2024-12-13 06:27:19,362 steps INFO] Response from faucet: Added to list [steps.py:1851 in request_faucet]
[2024-12-13 06:27:19,364 steps INFO] Requesting 1.0 dEGLD from r3d4 faucet for diana (erd1hyqgwux08z8p88exh4vth46as8l4luq9tzk3vpvwac3xcew3wv2suhf827) [steps.py:1814 in execute]
[2024-12-13 06:27:19,441 steps INFO] Response from faucet: Added to list [steps.py:1851 in request_faucet]
[2024-12-13 06:27:19,444 steps INFO] Requesting 1.0 dEGLD from r3d4 faucet for eve (erd1m8hnjq7fwp6fejs3ycw4g5c03aqr7w4nwk2k4f8s9ng2nler4p7szwu5ec) [steps.py:1814 in execute]
[2024-12-13 06:27:19,524 steps INFO] Response from faucet: Added to list [steps.py:1851 in request_faucet]
[2024-12-13 06:27:19,526 steps INFO] Requesting 1.0 dEGLD from r3d4 faucet for franck (erd1e70m48wpry5ldlm7trq32avwfjhgln62l4dd7u6y3zucr4sk77ks4vmndv) [steps.py:1814 in execute]
[2024-12-13 06:27:19,831 steps INFO] Response from faucet: Added to list [steps.py:1851 in request_faucet]
[2024-12-13 06:27:19,832 steps INFO] Requesting 1.0 dEGLD from r3d4 faucet for grace (erd1ue3plqqqzsvdtexae0fu6p42s7e4nu6qly46sz3y7ggtxe93zc0quf3q2j) [steps.py:1814 in execute]
[2024-12-13 06:27:20,025 steps INFO] Response from faucet: Added to list [steps.py:1851 in request_faucet]
[2024-12-13 06:27:20,027 steps INFO] Requesting 1.0 dEGLD from r3d4 faucet for hank (erd1wcllvmj3frc8t7h48lfpyv2g9nwdjmdeyf3g8px40pvma6vhqvnq4vtmaj) [steps.py:1814 in execute]
[2024-12-13 06:27:20,245 steps INFO] Response from faucet: Added to list [steps.py:1851 in request_faucet]
[2024-12-13 06:27:20,247 steps INFO] Requesting 1.0 dEGLD from r3d4 faucet for jack (erd1vhswl4cxr3zlqmreu2kmxm47amvzhg0e40h0qyn5j7yrajp4xpfq3alkpw) [steps.py:1814 in execute]
[2024-12-13 06:27:20,475 steps INFO] Response from faucet: Added to list [steps.py:1851 in request_faucet]
```

The results are the following:

| Account name | Shard |                                                                                    Account Address                                                                                   |                                                                                      Faucet Transaction                                                                                      |
|:------------:|:-----:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| alice        |   0   | [ erd1cnef85j3427z579rjdlelrhjgm96zjfpt0c2hnwhzew0ks74832q3rjnk5 ]( https://devnet-explorer.multiversx.com/accounts/erd1cnef85j3427z579rjdlelrhjgm96zjfpt0c2hnwhzew0ks74832q3rjnk5 ) | [ ece1a302ee6383df72197e793bfcd9a6dceb63ea4e8b229b932a2e6d6a5130e2 ]( https://devnet-explorer.multiversx.com/transactions/ece1a302ee6383df72197e793bfcd9a6dceb63ea4e8b229b932a2e6d6a5130e2 ) |
| bob          |   0   | [ erd163vmy4q7xsm9p8whcvve9sqaftrzv73rcqp2ledhmgrqgpvu6c7q7wtge9 ]( https://devnet-explorer.multiversx.com/accounts/erd163vmy4q7xsm9p8whcvve9sqaftrzv73rcqp2ledhmgrqgpvu6c7q7wtge9 ) | [ 4594ede673229381f0d79496fc8f53e02f9020d12b7e1de76b3cc83d60d8f5dc ]( https://devnet-explorer.multiversx.com/transactions/4594ede673229381f0d79496fc8f53e02f9020d12b7e1de76b3cc83d60d8f5dc ) |
| charlie      |   0   | [ erd1z9jx2w626u6xjv887hv70d7peavk7wunqw8d830lrsp3x0p0k27queg55n ]( https://devnet-explorer.multiversx.com/accounts/erd1z9jx2w626u6xjv887hv70d7peavk7wunqw8d830lrsp3x0p0k27queg55n ) | [ e2e23554c9f2b8cad26f3b59b38e2576071664874c27daa9b62539d5b58cbe6e ]( https://devnet-explorer.multiversx.com/transactions/e2e23554c9f2b8cad26f3b59b38e2576071664874c27daa9b62539d5b58cbe6e ) |
| diana        |   1   | [ erd1hyqgwux08z8p88exh4vth46as8l4luq9tzk3vpvwac3xcew3wv2suhf827 ]( https://devnet-explorer.multiversx.com/accounts/erd1hyqgwux08z8p88exh4vth46as8l4luq9tzk3vpvwac3xcew3wv2suhf827 ) | [ 7f8648b829be0ca88846b4328d82d81912602d79aa8dacb093dfdf0ba5e7400f ]( https://devnet-explorer.multiversx.com/transactions/7f8648b829be0ca88846b4328d82d81912602d79aa8dacb093dfdf0ba5e7400f ) |
| eve          |   1   | [ erd1m8hnjq7fwp6fejs3ycw4g5c03aqr7w4nwk2k4f8s9ng2nler4p7szwu5ec ]( https://devnet-explorer.multiversx.com/accounts/erd1m8hnjq7fwp6fejs3ycw4g5c03aqr7w4nwk2k4f8s9ng2nler4p7szwu5ec ) | [ d7570474c21df9a4951996de93d4cf78a50716cb51a4f438831111ff68a2f362 ]( https://devnet-explorer.multiversx.com/transactions/d7570474c21df9a4951996de93d4cf78a50716cb51a4f438831111ff68a2f362 ) |
| franck       |   1   | [ erd1e70m48wpry5ldlm7trq32avwfjhgln62l4dd7u6y3zucr4sk77ks4vmndv ]( https://devnet-explorer.multiversx.com/accounts/erd1e70m48wpry5ldlm7trq32avwfjhgln62l4dd7u6y3zucr4sk77ks4vmndv ) | [ 1f57a957efebd349e90d06f7ea839c10d191f54bc70f259278e95e83aea0dbf0 ]( https://devnet-explorer.multiversx.com/transactions/1f57a957efebd349e90d06f7ea839c10d191f54bc70f259278e95e83aea0dbf0 ) |
| grace        |   2   | [ erd1ue3plqqqzsvdtexae0fu6p42s7e4nu6qly46sz3y7ggtxe93zc0quf3q2j ]( https://devnet-explorer.multiversx.com/accounts/erd1ue3plqqqzsvdtexae0fu6p42s7e4nu6qly46sz3y7ggtxe93zc0quf3q2j ) | [ e2cd1b83b956d0b2def1aab31af68af05c61f91de04785bf28170af0615fe4f7 ]( https://devnet-explorer.multiversx.com/transactions/e2cd1b83b956d0b2def1aab31af68af05c61f91de04785bf28170af0615fe4f7 ) |
| hank         |   2   | [ erd1wcllvmj3frc8t7h48lfpyv2g9nwdjmdeyf3g8px40pvma6vhqvnq4vtmaj ]( https://devnet-explorer.multiversx.com/accounts/erd1wcllvmj3frc8t7h48lfpyv2g9nwdjmdeyf3g8px40pvma6vhqvnq4vtmaj ) | [ c4bdcef37d86e46df713506b47ff6645b1449f20a8f133feea709a24d3064669 ]( https://devnet-explorer.multiversx.com/transactions/c4bdcef37d86e46df713506b47ff6645b1449f20a8f133feea709a24d3064669 ) |
| jack         |   2   | [ erd1vhswl4cxr3zlqmreu2kmxm47amvzhg0e40h0qyn5j7yrajp4xpfq3alkpw ]( https://devnet-explorer.multiversx.com/accounts/erd1vhswl4cxr3zlqmreu2kmxm47amvzhg0e40h0qyn5j7yrajp4xpfq3alkpw ) | [ 9e01d47c42a1a51a5c6a9d2edf43285f45754155f4e638b578a43fefac574378 ]( https://devnet-explorer.multiversx.com/transactions/9e01d47c42a1a51a5c6a9d2edf43285f45754155f4e638b578a43fefac574378 ) |



That's it for the first challenge! Don't hesitate to clone this [repo](https://github.com/Catenscia/MxOps) and execute it on your computer to familiarise yourself with MxOps 😊