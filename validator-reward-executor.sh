#!/usr/bin/env bash
set -e
source <(grep -v '^#' "./.env" | sed -E 's|^(.+)=(.*)$|: ${\1=\2}; export \1|g')

rewards=$(
	cast call $VALIDATOR_REWARD_MANAGER "getStateOfRewards(address) returns (uint256,uint256)" $VALIDATOR_REWARD_OWNER \
	--rpc-url $RPC_URL)

nums=($(echo "$rewards" | grep -oE '[0-9]{10,}'))
total="${nums[0]}"
claimed="${nums[1]}"

if echo "$total $claimed" | awk '{exit !($1 <= $2)}'; then
  echo "no rewards to claim"
  exit 1
fi

claimable=$(echo "$total - $claimed" | bc)
cast send $VALIDATOR_REWARD_MANAGER "claim(address,address,uint256,bool)" \
  $VALIDATOR_REWARD_OWNER $VALIDATOR_REWARD_RECIPIENT $claimable true \
  --private-key $VALIDATOR_EXECUTOR_PVK \
  --rpc-url $RPC_URL
