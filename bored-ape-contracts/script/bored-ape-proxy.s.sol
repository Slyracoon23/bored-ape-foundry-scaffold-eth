// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/UpgradeUUPS.sol";

import "../src/bored-ape-proxy.sol";

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SewerPassProxyScript is Script {
    UUPSProxy proxy;

    SewerPassProxy wrappedProxyV1;

    ERC721 constant ApeNFTs =
        ERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
    ERC721 constant MutantNFTs =
        ERC721(0x60E4d786628Fea6478F785A6d7e704777c86a7c6);
    ERC721 constant KennelNFTs =
        ERC721(0xba30E5F9Bb24caa003E9f2f0497Ad287FDF95623);

    IBAYCSewerPassClaim constant SewerPassClaim =
        IBAYCSewerPassClaim(0xBA5a9E9CBCE12c70224446C24C111132BECf9F1d);

    IBAYCSewerPass constant SewerNFTs =
        IBAYCSewerPass(0x764AeebcF425d56800eF2c84F2578689415a2DAa);

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.broadcast(deployerPrivateKey);

        SewerPassProxy implementationV1 = new SewerPassProxy();

        // deploy proxy contract and point it to implementation
        proxy = new UUPSProxy(address(implementationV1), "");

        // wrap in ABI to support easier calls
        wrappedProxyV1 = SewerPassProxy(address(proxy));
        wrappedProxyV1.initialize(
            address(SewerPassClaim),
            address(SewerNFTs),
            address(ApeNFTs),
            address(MutantNFTs),
            address(KennelNFTs)
        );

        vm.stopBroadcast();
    }
}
