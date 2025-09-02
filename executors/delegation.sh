#!/usr/bin/env bash
set -e
source <(grep -v '^#' "./.env" | sed -E 's|^(.+)=(.*)$|: ${\1=\2}; export \1|g')

reward_epoch=$1

cast send $REWARD_MANAGER "claim(address,address,uint24,bool,(bytes32[],(uint24,bytes20,uint120,uint8))[])" \
    $DELEGATION_REWARD_OWNER $DELEGATION_REWARD_RECIPIENT $reward_epoch true "[]" \
    --private-key $DELEGATION_EXECUTOR_PVK --rpc-url $RPC_URL