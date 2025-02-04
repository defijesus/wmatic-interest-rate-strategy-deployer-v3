# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update   :; forge update
install  :; forge install

# Build & test
build    :; forge clean && forge build
test     :; forge clean && forge test --etherscan-api-key ${ETHERSCAN_API_KEY} $(call compute_test_verbosity,${V}) # Usage: make test [optional](V=<{1,2,3,4,5}>)
match    :; forge clean && forge test --etherscan-api-key ${ETHERSCAN_API_KEY} -m ${MATCH} $(call compute_test_verbosity,${V}) # Usage: make match MATCH=<TEST_FUNCTION_NAME> [optional](V=<{1,2,3,4,5}>)
report   :; forge clean && forge test --gas-report | sed -e/╭/\{ -e:1 -en\;b1 -e\} -ed | cat > .gas-report

# Deploy and Verify Contract
deploy-contract :; forge script script/DeployContract.s.sol:DeployContract --rpc-url ${RPC_POLYGON_URL} --broadcast --chain-id 137 --ledger --sender 0xde30040413b26d7aa2b6fc4761d80eb35dcf97ad --verify --etherscan-api-key ${POLYGONSCAN_API_KEY} -vvvv
verify-contract :; forge script script/DeployContract.s.sol:DeployContract --rpc-url ${RPC_POLYGON_URL} --verify --etherscan-api-key ${POLYGONSCAN_API_KEY} -vvvv

# Clean & lint
clean    :; forge clean
lint     :; npx prettier --write */*.sol

# Defaults to -v if no V=<{1,2,3,4,5} specified
define compute_test_verbosity
$(strip \
$(if $(filter 1,$(1)),-v,\
$(if $(filter 2,$(1)),-vv,\
$(if $(filter 3,$(1)),-vvv,\
$(if $(filter 4,$(1)),-vvvv,\
$(if $(filter 5,$(1)),-vvvvv,\
-v
))))))
endef
