#!/usr/bin/env bash
set -e
source <(grep -v '^#' "./.env" | sed -E 's|^(.+)=(.*)$|: ${\1=\2}; export \1|g')

reward_epoch=$1

serialize_reward_tuple() {
  jq -r '
    . as [$proofs, [$epoch, $beneficiary, $amount, $claimType]] |
    "[(["
    + ($proofs | join(","))
    + "],("
    + ($epoch|tostring)
    + "," + $beneficiary
    + "," + ($amount|tostring)
    + "," + ($claimType|tostring)
    + "))]"
'
}

# get owner's reward tuple
reward_tuples_url=$REWARD_TUPLES_URL/$reward_epoch/reward-distribution-data-tuples.json
lower_owner="${FSP_REWARD_OWNER,,}"
reward_tuple=$(curl -s "$reward_tuples_url" | jq --arg owner "$lower_owner" \
  '.rewardClaims[] | select(.[1][1] == $owner)')

# calculate new amounts to claim
amount=$(echo $reward_tuple | jq -r .[1][2])

if [[ "$amount" -eq 0 ]]; then
    echo "first amount cannot be claimed"
    exit 1
fi

# serialize reward tuple
s_reward_tuple=$(echo "$reward_tuple" | serialize_reward_tuple)

# claim
cast send $REWARD_MANAGER "claim(address,address,uint24,bool,(bytes32[],(uint24,bytes20,uint120,uint8))[])" \
    $FSP_REWARD_OWNER $FSP_REWARD_RECIPIENT $reward_epoch true "$s_reward_tuple" \
    --private-key $FSP_EXECUTOR_PVK --rpc-url $RPC_URL