// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/bored-ape-proxy.sol";

import {MockERC721} from "./mock/MockERC721.sol";

contract EscrowTest is Test {
    address constant RECIPIENT = address(10);
    Escrow public escrow;

    MockERC721 public mockERC721;

    function setUp() public {
        escrow = new Escrow();

        mockERC721 = new MockERC721();
    }

    function testDepost() public {
        // Mint NFT for RECIPIENT
        mockERC721.mint(RECIPIENT, 0);

        // Approve escrow to transfer NFT
        vm.startPrank(RECIPIENT);
        mockERC721.approve(address(escrow), 0);

        // Deposit NFT into escrow
        escrow.depositNFT(address(mockERC721), 0);

        assertEq(mockERC721.ownerOf(0), address(escrow));
    }

    function testWithdrawl() public {
        // Mint NFT for RECIPIENT
        mockERC721.mint(RECIPIENT, 0);

        // Approve escrow to transfer NFT
        vm.startPrank(RECIPIENT);
        mockERC721.approve(address(escrow), 0);

        // Deposit NFT into escrow
        escrow.depositNFT(address(mockERC721), 0);

        // Withdrawl NFT from escrow
        escrow.withdrawlNFT(address(mockERC721), 0);

        assertEq(mockERC721.ownerOf(0), RECIPIENT);
    }

    function testApprovedNFTsListByOwner() public {
        // Mint NFT for RECIPIENT
        mockERC721.mint(RECIPIENT, 0);
        mockERC721.mint(RECIPIENT, 1);

        // Approve escrow to transfer NFT
        vm.startPrank(RECIPIENT);
        mockERC721.setApprovalForAll(address(escrow), true);

        uint256[] memory approvedNFT_tokenId_list = escrow
            .getApprovedNFTsByOwner(address(mockERC721), RECIPIENT);

        assertEq(approvedNFT_tokenId_list.length, 2);

        assertEq(mockERC721.ownerOf(approvedNFT_tokenId_list[0]), RECIPIENT);
        assertEq(mockERC721.ownerOf(approvedNFT_tokenId_list[1]), RECIPIENT);
    }

    function testAddApprovedHolder() public {
        // Mint NFT for RECIPIENT
        mockERC721.mint(RECIPIENT, 0);

        // Approve escrow to transfer NFT
        vm.startPrank(RECIPIENT);
        mockERC721.setApprovalForAll(address(escrow), true);

        escrow.addApprovedHolder(address(mockERC721), RECIPIENT);

        assertEq(escrow.nftApprovedHolders(0), RECIPIENT);
    }

    function testApprovedAll() public {
        // Mint NFT for RECIPIENT
        mockERC721.mint(RECIPIENT, 0);

        // Approve escrow to transfer NFT
        vm.startPrank(RECIPIENT);
        mockERC721.setApprovalForAll(address(escrow), true);
    }
}
