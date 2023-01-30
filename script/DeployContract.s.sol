// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "@forge-std/console.sol";
import {Script} from "@forge-std/Script.sol";
import {DefaultReserveInterestRateStrategy} from "@aave-v3/protocol/pool/DefaultReserveInterestRateStrategy.sol";
import {IPoolAddressesProvider} from "@aave-v3/interfaces/IPoolAddressesProvider.sol";

contract DeployContract is Script {
    IPoolAddressesProvider internal constant POOL_ADDRESSES_PROVIDER =
        IPoolAddressesProvider(0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb);

    function run() external {
        vm.startBroadcast();
        DefaultReserveInterestRateStrategy deployedContract = new DefaultReserveInterestRateStrategy(
            POOL_ADDRESSES_PROVIDER,
            750000000000000000000000000, // UOptimal
            0, // Base Variable Borrow Rate
            61000000000000000000000000, // Variable Slope 1
            1000000000000000000000000000, // Variable Slope 2
            0, // Stable Slope 1
            0, // Stable Slope 2
            20000000000000000000000000, // Base Stable Rate Offset
            50000000000000000000000000, // Stable Rate Excess Offset
            200000000000000000000000000 // Optimal Stable To Total Debt Ratio
        );
        console.log("Contract address: ", address(deployedContract));
        vm.stopBroadcast();
    }
}
