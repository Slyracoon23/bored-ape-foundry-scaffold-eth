// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/bored-ape-proxy.sol";

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

    SewerPassProxy sewerPassProxy;

    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"), 16434998); // fork mainnet at block 16434998

        sewerPassProxy = new SewerPassProxy(
            address(SewerPassClaim),
            address(SewerNFTs),
            address(ApeNFTs),
            address(MutantNFTs),
            address(KennelNFTs)
        );
    }

    function testTier4() public {
        vm.startPrank(KENNEL_ONWER);
        // Approve SewerProxy to transfer NFT
        KennelNFTs.setApprovalForAll(address(sewerPassProxy), true);

        // Add NFT to proxy list
        sewerPassProxy.addApprovedHolder(KENNEL_ONWER);

        vm.stopPrank();
        vm.startPrank(BORED_APE_OWNER);
        // Approve SewerProxy to transfer NFT
        ApeNFTs.setApprovalForAll(address(sewerPassProxy), true);

        // Get Ape tokenID
        uint256 tokenID = ERC721Enumerable(address(ApeNFTs))
            .tokenOfOwnerByIndex(BORED_APE_OWNER, 0);

        // Recieve the sewer pass
        sewerPassProxy.claimBaycBakc(tokenID);

        assertEq(SewerNFTs.balanceOf(BORED_APE_OWNER), 1);
    }

    // function testTier2() public {
    //     // Mint NFT for RECIPIENT
    //     ApeNFTs.mint(RECIPIENT, 0);

    //     vm.startPrank(RECIPIENT);

    //     SewerNFTs.mintSewerPass();

    //     assertEq(SewerNFTs.balanceOf(RECIPIENT, SewerNFTs.TIER2()), 1);
    // }

    // function testTierFail() public {
    //     // Approve escrow to transfer NFT
    //     vm.startPrank(RECIPIENT);

    //     vm.expectRevert("No sewer pass for you! No NFTs found!");
    //     SewerNFTs.mintSewerPass();
    // }
}
