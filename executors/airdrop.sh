#!/usr/bin/env bash
set -e
source <(grep -v '^#' "./.env" | sed -E 's|^(.+)=(.*)$|: ${\1=\2}; export \1|g')

month=$1

cast send $DISTRIBUTION_TO_DELEGATORS "claim(address,address,uint256,bool)" \
    $AIRDROP_REWARD_OWNER $AIRDROP_REWARD_RECIPIENT $month true \
    --rpc-url $RPC_URL --private-key $AIDROP_EXECUTOR_PVK