# MultiversX Winter Coding Challenge 2024

This repository is a submission for the [MultiversX Winter Coding Challenge 2024](https://multiversx.notion.site/multiversx-winter-coding-challenge), with the intent of using as much as possible the [MxOps](https://github.com/Catenscia/MxOps) tool.

Everyting will be explained as much as possible but if you get stuck at any point, don't hesitate to refer to the [MxOps documentation](https://mxops.readthedocs.io/en/latest/index.html) or reach me on my [X account](https://x.com/Etienne_Wallet)!

## Is this submission eligible for the challenge?

Good question! My goal is to use as much as possible the MxOps tool to showcase how it can streamline the developper experience on MultiversX by making it really easy to interact with the MultiversX blockchain.
I build MxOps on top of the py-skd from the core team of MultiversX, so I would argue that this submission is valid, however, I will let the judge decide on that 😊

## Structure

This repository is organised to show every challenges as they are submitted: each challenge have its own dedicated folder in the [challenges folder](./challenges). So even if a challenge is aimed to be an improvment over a previous challenge, it will still have a new dedicated folder.

Each challenge will be described extensively with a `README.md` and will have the necessary scripts to be executed on the devnet and on the chain-simulator.
The chain simulator will be used to check that everything is correct before executing each challenge on the devnet.

The only common ressources between the challenges will be the [wallets folder](./wallets), where the pem wallets will be stored. (The wallets won't be open sourced to avoid anyone messing with this submission)

## Dependencies

As said in the introduction, my goal is to use [MxOps](https://github.com/Catenscia/MxOps) as much as possible. I will even develop new MxOps features to cover the needs for this challenge.
This means that the challenges will depends on the latest develop version of MxOps (a reminder will be written in each challenge if an update is needed).


```bash
pipx install git+https://github.com/Catenscia/MxOps@develop --force
```

## Execution

All challenges are meant to be executed as standalone projets, so for each challenge, the assumed current working directory is the folder of the said challenge.