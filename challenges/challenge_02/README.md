# Challenge 2

Official description of the challenge: https://multiversx.notion.site/4-December-15173522fb4d80af82fdc869cfc08fbb

## Objectives

We want to make each of the account generated during challenge #01 issue a fungible token with a supply of 100 millions token each.
The tokens must a have a `WINTER` ticker, have 8 decimals and no restrictions for properties.

```{note}
In the official description of the challenge #02, it is said to issue three tokens and then one token per account generated at challenge #01 which are two incoherent statements. We will interpret that 9 tokens should be generated as we created 9 accounts during challenge #01.
```

## Tutorial

### Dependencies

This challenge will use the develop [MxOps](https://github.com/Catenscia/MxOps) version `3.0.0.dev15`, be sure to have it updated.

```bash
pipx install git+https://github.com/Catenscia/MxOps@develop --force
```

For this challenge #02, the following feature has been specifically added to MxOps:

- Variable composition: [MxOps PR#91](https://github.com/Catenscia/MxOps/pull/91)


### Steps

We will tackle this challenge by using the [`FungibleIssue`](https://mxops.readthedocs.io/en/latest/user_documentation/steps.html#issuance-step) step from MxOps. To differentiate between the tokens, we will name each token '<user>WinterToken'.


Let's create the scene [01_generate_tokens.yaml](./mxops_scenes/01_generate_tokens.yaml):

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
  - type: Loop
    var_name: user
    var_list: "%user_accounts"
    steps:
      - type: FungibleIssue
        sender: "%user"
        token_name: "%{user}WinterToken"
        token_ticker: WINTER
        initial_supply: 100_000_000_00000000  # 100M
        num_decimals: 8
        can_freeze: true
        can_wipe: true
        can_pause: true
        can_change_owner: true
        can_upgrade: true
        can_add_special_roles: true
```

Some details:

- As during the challeng #01, all the loading accounts are listed in the variable `user_accounts`. By looping over it, the `user` variable will represent each of the token owner (alice, then bob, then charlie, ...)
- To personalize the token name depending on the owner, we use the [variable composition](https://mxops.readthedocs.io/en/latest/user_documentation/values.html#composability) of MxOps: In the string "%{user}WinterToken", the sub string "%{user}" will be replaced by the value of stored by the variable user. When the user is "alice", this will give us "aliceWinterToken".
- The initial supply of 100 millions is written in full int, so the last height zeros represent the decimals


## Run and Results

We will run this challenge with a simple command line, by invoking MxOps on the scene we have written:

```bash
mxops \
    execute \
    -n devnet \
    -s mx-winter-coding-challenge \
    mxops_scenes/01_generate_tokens.yaml
```

This will give an output looking like this

```
MxOps  Copyright (C) 2023  Catenscia 
This program comes with ABSOLUTELY NO WARRANTY
[2024-12-16 16:14:06,627 data INFO] Scenario mx-winter-coding-challenge created for network devnet [execution_data.py:674 in create_scenario]
[2024-12-16 16:14:06,628 scene INFO] Executing scene mxops_scenes/01_generate_tokens.yaml [scene.py:74 in execute_scene]
[2024-12-16 16:14:07,732 steps INFO] Issuing fungible token named aliceWinterToken for the account %user (erd1cnef85j3427z579rjdlelrhjgm96zjfpt0c2hnwhzew0ks74832q3rjnk5) [steps.py:937 in build_unsigned_transaction]
[2024-12-16 16:14:33,495 steps INFO] Transaction successful: https://devnet-explorer.multiversx.com/transactions/8b05e3289bc40f699940ec01f84f632aa979558bfa4f03414f96992a423fa0ab [steps.py:155 in execute]
[2024-12-16 16:14:33,495 steps INFO] Newly issued token got the identifier WINTER-0cb519 [steps.py:974 in _post_transaction_execution]
[2024-12-16 16:14:33,496 steps INFO] Issuing fungible token named bobWinterToken for the account %user (erd163vmy4q7xsm9p8whcvve9sqaftrzv73rcqp2ledhmgrqgpvu6c7q7wtge9) [steps.py:937 in build_unsigned_transaction]
[2024-12-16 16:15:05,545 steps INFO] Transaction successful: https://devnet-explorer.multiversx.com/transactions/92dbc9f68eae13b3343f903cef74fba87d7d337c7fa4548375f5181b5f4554d0 [steps.py:155 in execute]
[2024-12-16 16:15:05,545 steps INFO] Newly issued token got the identifier WINTER-5202af [steps.py:974 in _post_transaction_execution]
[2024-12-16 16:15:05,546 steps INFO] Issuing fungible token named chalieWinterToken for the account %user (erd1z9jx2w626u6xjv887hv70d7peavk7wunqw8d830lrsp3x0p0k27queg55n) [steps.py:937 in build_unsigned_transaction]
[2024-12-16 16:15:34,303 steps INFO] Transaction successful: https://devnet-explorer.multiversx.com/transactions/020baff87431a3e7d53280dd7eafe4e27986ea489b39f8d6406d117144f7b846 [steps.py:155 in execute]
[2024-12-16 16:15:34,304 steps INFO] Newly issued token got the identifier WINTER-d5f118 [steps.py:974 in _post_transaction_execution]
[2024-12-16 16:15:34,305 steps INFO] Issuing fungible token named dianaWinterToken for the account %user (erd1hyqgwux08z8p88exh4vth46as8l4luq9tzk3vpvwac3xcew3wv2suhf827) [steps.py:937 in build_unsigned_transaction]
[2024-12-16 16:16:03,008 steps INFO] Transaction successful: https://devnet-explorer.multiversx.com/transactions/939b0d8835c9a27cdc382c915f41a0670450c6afbede1d8450c25a6ebbf83c58 [steps.py:155 in execute]
[2024-12-16 16:16:03,009 steps INFO] Newly issued token got the identifier WINTER-8f8ef0 [steps.py:974 in _post_transaction_execution]
[2024-12-16 16:16:03,011 steps INFO] Issuing fungible token named eveWinterToken for the account %user (erd1m8hnjq7fwp6fejs3ycw4g5c03aqr7w4nwk2k4f8s9ng2nler4p7szwu5ec) [steps.py:937 in build_unsigned_transaction]
[2024-12-16 16:16:35,068 steps INFO] Transaction successful: https://devnet-explorer.multiversx.com/transactions/595f3203016a01f6b36499fab628d9387434eb79dc1e68472611ed7fdd52e4c2 [steps.py:155 in execute]
[2024-12-16 16:16:35,068 steps INFO] Newly issued token got the identifier WINTER-14e07f [steps.py:974 in _post_transaction_execution]
[2024-12-16 16:16:35,070 steps INFO] Issuing fungible token named franckWinterToken for the account %user (erd1e70m48wpry5ldlm7trq32avwfjhgln62l4dd7u6y3zucr4sk77ks4vmndv) [steps.py:937 in build_unsigned_transaction]
[2024-12-16 16:17:03,953 steps INFO] Transaction successful: https://devnet-explorer.multiversx.com/transactions/98736ea10ef57d037f3c1e3fa627ac621be1a3a8c4d065b41de24d3d59d24b5e [steps.py:155 in execute]
[2024-12-16 16:17:03,953 steps INFO] Newly issued token got the identifier WINTER-1c20e4 [steps.py:974 in _post_transaction_execution]
[2024-12-16 16:17:03,954 steps INFO] Issuing fungible token named graceWinterToken for the account %user (erd1ue3plqqqzsvdtexae0fu6p42s7e4nu6qly46sz3y7ggtxe93zc0quf3q2j) [steps.py:937 in build_unsigned_transaction]
[2024-12-16 16:17:32,599 steps INFO] Transaction successful: https://devnet-explorer.multiversx.com/transactions/18ecdca7f4168e0a4ba616103c172d366fb4c5eab0dc6350c2f775d324d3abc6 [steps.py:155 in execute]
[2024-12-16 16:17:32,600 steps INFO] Newly issued token got the identifier WINTER-bd84e0 [steps.py:974 in _post_transaction_execution]
[2024-12-16 16:17:32,601 steps INFO] Issuing fungible token named hankWinterToken for the account %user (erd1wcllvmj3frc8t7h48lfpyv2g9nwdjmdeyf3g8px40pvma6vhqvnq4vtmaj) [steps.py:937 in build_unsigned_transaction]
[2024-12-16 16:18:04,492 steps INFO] Transaction successful: https://devnet-explorer.multiversx.com/transactions/70cb789ec8bebe706b74793e1e2cab3551e3e5573e117510cac4ddb7eac34caa [steps.py:155 in execute]
[2024-12-16 16:18:04,492 steps INFO] Newly issued token got the identifier WINTER-9cdc40 [steps.py:974 in _post_transaction_execution]
[2024-12-16 16:18:04,493 steps INFO] Issuing fungible token named jackWinterToken for the account %user (erd1vhswl4cxr3zlqmreu2kmxm47amvzhg0e40h0qyn5j7yrajp4xpfq3alkpw) [steps.py:937 in build_unsigned_transaction]
[2024-12-16 16:18:33,019 steps INFO] Transaction successful: https://devnet-explorer.multiversx.com/transactions/5e7a8389be7746c7e799f2753de8778ac0443c599fb494d1c02c4ac497df448d [steps.py:155 in execute]
[2024-12-16 16:18:33,020 steps INFO] Newly issued token got the identifier WINTER-4d86e1 [steps.py:974 in _post_transaction_execution]
```

Here are the results in a table format:

| User                                                                                                                    | Fungible issue transaction                                                                                                                                                               | Issued Token                                                                 |
|-------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------|
| [alice](https://devnet-explorer.multiversx.com/accounts/erd1cnef85j3427z579rjdlelrhjgm96zjfpt0c2hnwhzew0ks74832q3rjnk5) | [8b05e3289bc40f699940ec01f84f632aa979558bfa4f03414f96992a423fa0ab](https://devnet-explorer.multiversx.com/transactions/8b05e3289bc40f699940ec01f84f632aa979558bfa4f03414f96992a423fa0ab) | [WINTER-0cb519](https://devnet-explorer.multiversx.com/tokens/WINTER-0cb519) |
| [bob](https://devnet-explorer.multiversx.com/accounts/erd163vmy4q7xsm9p8whcvve9sqaftrzv73rcqp2ledhmgrqgpvu6c7q7wtge9) | [92dbc9f68eae13b3343f903cef74fba87d7d337c7fa4548375f5181b5f4554d0](https://devnet-explorer.multiversx.com/transactions/92dbc9f68eae13b3343f903cef74fba87d7d337c7fa4548375f5181b5f4554d0) | [WINTER-5202af](https://devnet-explorer.multiversx.com/tokens/WINTER-5202af) |
| [charlie](https://devnet-explorer.multiversx.com/accounts/erd1z9jx2w626u6xjv887hv70d7peavk7wunqw8d830lrsp3x0p0k27queg55n) | [020baff87431a3e7d53280dd7eafe4e27986ea489b39f8d6406d117144f7b846](https://devnet-explorer.multiversx.com/transactions/020baff87431a3e7d53280dd7eafe4e27986ea489b39f8d6406d117144f7b846) | [WINTER-d5f118](https://devnet-explorer.multiversx.com/tokens/WINTER-d5f118) |
| [diana](https://devnet-explorer.multiversx.com/accounts/erd1hyqgwux08z8p88exh4vth46as8l4luq9tzk3vpvwac3xcew3wv2suhf827) | [939b0d8835c9a27cdc382c915f41a0670450c6afbede1d8450c25a6ebbf83c58](https://devnet-explorer.multiversx.com/transactions/939b0d8835c9a27cdc382c915f41a0670450c6afbede1d8450c25a6ebbf83c58) | [WINTER-8f8ef0](https://devnet-explorer.multiversx.com/tokens/WINTER-8f8ef0) |
| [eve](https://devnet-explorer.multiversx.com/accounts/erd1m8hnjq7fwp6fejs3ycw4g5c03aqr7w4nwk2k4f8s9ng2nler4p7szwu5ec) | [595f3203016a01f6b36499fab628d9387434eb79dc1e68472611ed7fdd52e4c2](https://devnet-explorer.multiversx.com/transactions/595f3203016a01f6b36499fab628d9387434eb79dc1e68472611ed7fdd52e4c2) | [WINTER-14e07f](https://devnet-explorer.multiversx.com/tokens/WINTER-14e07f) |
| [franck](https://devnet-explorer.multiversx.com/accounts/erd1e70m48wpry5ldlm7trq32avwfjhgln62l4dd7u6y3zucr4sk77ks4vmndv) | [98736ea10ef57d037f3c1e3fa627ac621be1a3a8c4d065b41de24d3d59d24b5e](https://devnet-explorer.multiversx.com/transactions/98736ea10ef57d037f3c1e3fa627ac621be1a3a8c4d065b41de24d3d59d24b5e) | [WINTER-1c20e4](https://devnet-explorer.multiversx.com/tokens/WINTER-1c20e4) |
| [grace](https://devnet-explorer.multiversx.com/accounts/erd1ue3plqqqzsvdtexae0fu6p42s7e4nu6qly46sz3y7ggtxe93zc0quf3q2j) | [18ecdca7f4168e0a4ba616103c172d366fb4c5eab0dc6350c2f775d324d3abc6](https://devnet-explorer.multiversx.com/transactions/18ecdca7f4168e0a4ba616103c172d366fb4c5eab0dc6350c2f775d324d3abc6) | [WINTER-bd84e0](https://devnet-explorer.multiversx.com/tokens/WINTER-bd84e0) |
| [hank](https://devnet-explorer.multiversx.com/accounts/erd1wcllvmj3frc8t7h48lfpyv2g9nwdjmdeyf3g8px40pvma6vhqvnq4vtmaj) | [70cb789ec8bebe706b74793e1e2cab3551e3e5573e117510cac4ddb7eac34caa](https://devnet-explorer.multiversx.com/transactions/70cb789ec8bebe706b74793e1e2cab3551e3e5573e117510cac4ddb7eac34caa) | [WINTER-9cdc40](https://devnet-explorer.multiversx.com/tokens/WINTER-9cdc40) |
| [jack](https://devnet-explorer.multiversx.com/accounts/erd1vhswl4cxr3zlqmreu2kmxm47amvzhg0e40h0qyn5j7yrajp4xpfq3alkpw) | [5e7a8389be7746c7e799f2753de8778ac0443c599fb494d1c02c4ac497df448d](https://devnet-explorer.multiversx.com/transactions/5e7a8389be7746c7e799f2753de8778ac0443c599fb494d1c02c4ac497df448d) | [WINTER-4d86e1](https://devnet-explorer.multiversx.com/tokens/WINTER-4d86e1) |

That's it for the second challenge! Don't hesitate to clone this [repo](https://github.com/Catenscia/MxOps) and execute it on your computer to familiarise yourself with MxOps 😊