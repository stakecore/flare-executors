# Flare and Songbird Reward Executors

The repository contains bash scripts for Flare/Songbird validator and fsp reward executors. To set up:
- install [foundry](https://getfoundry.sh/introduction/installation/),
- run `apt-get install bc jq curl`,
- copy `.env.template` to `.env`,
- fill the missing `.env` values,
- run `bash fsp-reward-executor.sh` or `bash validator-reward-executor.sh`.