// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/bored-ape-proxy.sol";
import "../src/UpgradeUUPS.sol";

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {MockERC721} from "./mock/MockERC721.sol";

import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SewerPassTest is Test {
    address constant BORED_APE_OWNER =
        address(0x5d5335e6bEA4B12dCB942Cec1DA951aE63f2ae64); // Bored Ape Holder
    address constant MUTANT_APE_OWNER =
        address(0xe80eF3e29C4A8DE3867260104befB1AE2d88DE57); // Mutant Ape Holder
    address constant KENNEL_ONWER =
        address(0x0946bC5c2F9848665CC3811458De403d0A78AD8E); // Kennel DOG Holder

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

    SewerPassProxy implementationV1;
    UUPSProxy proxy;
    SewerPassProxy wrappedProxyV1;

    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"), 16434998); // fork mainnet at block 16434998

        implementationV1 = new SewerPassProxy();
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
    }

    function testTier4() public {
        uint256 kennelBalance = KennelNFTs.balanceOf(KENNEL_ONWER);
        uint256 apeBalance = ApeNFTs.balanceOf(BORED_APE_OWNER);

        vm.startPrank(KENNEL_ONWER);
        // Approve SewerProxy to transfer NFT
        KennelNFTs.setApprovalForAll(address(wrappedProxyV1), true);

        // Add NFT to proxy list
        wrappedProxyV1.addApprovedHolder(KENNEL_ONWER);

        vm.stopPrank();
        vm.startPrank(BORED_APE_OWNER);
        // Approve SewerProxy to transfer NFT
        ApeNFTs.setApprovalForAll(address(wrappedProxyV1), true);

        // Get Ape tokenID
        uint256 tokenID = ERC721Enumerable(address(ApeNFTs))
            .tokenOfOwnerByIndex(BORED_APE_OWNER, 0);

        // Recieve the sewer pass
        wrappedProxyV1.claimBaycBakc{value: 1 ether}(tokenID);

        assertEq(SewerNFTs.balanceOf(BORED_APE_OWNER), 1);
        assertEq(KennelNFTs.balanceOf(KENNEL_ONWER), kennelBalance);
        assertEq(ApeNFTs.balanceOf(BORED_APE_OWNER), apeBalance);
        assertEq(address(wrappedProxyV1).balance, 1 ether - 0.1 ether);
    }

    function testTier2() public {
        uint256 kennelBalance = KennelNFTs.balanceOf(KENNEL_ONWER);
        uint256 mutantBalance = MutantNFTs.balanceOf(MUTANT_APE_OWNER);

        vm.startPrank(KENNEL_ONWER);
        // Approve SewerProxy to transfer NFT
        KennelNFTs.setApprovalForAll(address(wrappedProxyV1), true);

        // Add NFT to proxy list
        wrappedProxyV1.addApprovedHolder(KENNEL_ONWER);

        vm.stopPrank();
        vm.startPrank(MUTANT_APE_OWNER);
        // Approve SewerProxy to transfer NFT
        MutantNFTs.setApprovalForAll(address(wrappedProxyV1), true);

        // Get Ape tokenID
        uint256 tokenID = ERC721Enumerable(address(MutantNFTs))
            .tokenOfOwnerByIndex(MUTANT_APE_OWNER, 0);

        // Recieve the sewer pass
        wrappedProxyV1.claimMaycBakc{value: 1 ether}(tokenID);

        assertEq(SewerNFTs.balanceOf(MUTANT_APE_OWNER), 1);
        assertEq(KennelNFTs.balanceOf(KENNEL_ONWER), kennelBalance);
        assertEq(MutantNFTs.balanceOf(MUTANT_APE_OWNER), mutantBalance);
        assertEq(address(wrappedProxyV1).balance, 1 ether - 0.1 ether);
    }

    // function testTierFail() public {
    //     // Approve escrow to transfer NFT
    //     vm.startPrank(RECIPIENT);

    //     vm.expectRevert("No sewer pass for you! No NFTs found!");
    //     SewerNFTs.mintSewerPass();
    // }
}
