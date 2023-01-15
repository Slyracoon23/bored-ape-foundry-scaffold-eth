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
        mockERC721.approve(address(escrow), 0);

        // Deposit NFT into escrow
        escrow.depositNFT(address(mockERC721), 0);

        address ownerNFT = mockERC721.ownerOf(0);

        assertEq(ownerNFT, address(escrow));
    }

    // function testWithdrawl(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
