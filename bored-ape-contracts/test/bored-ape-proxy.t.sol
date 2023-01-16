// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/bored-ape-proxy.sol";

import {MockERC721} from "./mock/MockERC721.sol";

import {MockERC1155} from "./mock/MockERC1155.sol";

// contract EscrowTest is Test {
//     address constant RECIPIENT = address(10);
//     address constant RECIPIENT2 = address(20);

//     Escrow public escrow;

//     MockERC721 public mockERC721;

//     function setUp() public {
//         escrow = new Escrow();

//         mockERC721 = new MockERC721();
//     }

//     function testDepost() public {
//         // Mint NFT for RECIPIENT
//         mockERC721.mint(RECIPIENT, 0);

//         // Approve escrow to transfer NFT
//         vm.startPrank(RECIPIENT);
//         mockERC721.approve(address(escrow), 0);

//         // Deposit NFT into escrow
//         escrow.depositNFT(address(mockERC721), 0);

//         assertEq(mockERC721.ownerOf(0), address(escrow));
//     }

//     function testWithdrawl() public {
//         // Mint NFT for RECIPIENT
//         mockERC721.mint(RECIPIENT, 0);

//         // Approve escrow to transfer NFT
//         vm.startPrank(RECIPIENT);
//         mockERC721.approve(address(escrow), 0);

//         // Deposit NFT into escrow
//         escrow.depositNFT(address(mockERC721), 0);

//         // Withdrawl NFT from escrow
//         escrow.withdrawlNFT(address(mockERC721), 0);

//         assertEq(mockERC721.ownerOf(0), RECIPIENT);
//     }

//     function testApprovedNFTsListByOwner() public {
//         // Mint NFT for RECIPIENT
//         mockERC721.mint(RECIPIENT, 0);
//         mockERC721.mint(RECIPIENT, 1);

//         // Approve escrow to transfer NFT
//         vm.startPrank(RECIPIENT);
//         mockERC721.setApprovalForAll(address(escrow), true);

//         uint256[] memory approvedNFT_tokenId_list = escrow
//             .getApprovedNFTsByOwner(address(mockERC721), RECIPIENT);

//         assertEq(approvedNFT_tokenId_list.length, 2);

//         assertEq(mockERC721.ownerOf(approvedNFT_tokenId_list[0]), RECIPIENT);
//         assertEq(mockERC721.ownerOf(approvedNFT_tokenId_list[1]), RECIPIENT);
//     }

//     // TODO: add fail AddApprovedHolder test

//     function testAddApprovedHolder() public {
//         // Mint NFT for RECIPIENT
//         mockERC721.mint(RECIPIENT, 0);

//         // Approve escrow to transfer NFT
//         vm.startPrank(RECIPIENT);
//         mockERC721.setApprovalForAll(address(escrow), true);

//         escrow.addApprovedHolder(address(mockERC721), RECIPIENT);

//         assertEq(escrow.nftApprovedHolders(0), RECIPIENT);
//     }

//     function testApprovedAll() public {
//         // Mint NFT for RECIPIENT
//         mockERC721.mint(RECIPIENT, 0);
//         mockERC721.mint(RECIPIENT, 2);

//         mockERC721.mint(RECIPIENT2, 1);

//         // Approve escrow to transfer NFT
//         vm.prank(RECIPIENT);
//         mockERC721.setApprovalForAll(address(escrow), true);

//         vm.prank(RECIPIENT2);
//         mockERC721.setApprovalForAll(address(escrow), true);

//         // Add approved holders
//         escrow.addApprovedHolder(address(mockERC721), RECIPIENT);
//         escrow.addApprovedHolder(address(mockERC721), RECIPIENT2);

//         // Measure gas cost
//         uint256 gas_start = gasleft();
//         uint256[] memory approvedNFT_tokenId_list = escrow.getAllApprovedNFTs(
//             address(mockERC721)
//         );
//         uint256 gas_used = gas_start - gasleft();
//         console.log("gas_used(function getAllAprovedNFT): ", gas_used);

//         assertEq(approvedNFT_tokenId_list.length, 3);

//         console.log(
//             "approvedNFT_tokenId_list[0]: ",
//             approvedNFT_tokenId_list[0]
//         );
//         assertEq(mockERC721.ownerOf(approvedNFT_tokenId_list[0]), RECIPIENT);
//         console.log(
//             "approvedNFT_tokenId_list[1]: ",
//             approvedNFT_tokenId_list[1]
//         );
//         assertEq(mockERC721.ownerOf(approvedNFT_tokenId_list[1]), RECIPIENT);
//         console.log(
//             "approvedNFT_tokenId_list[2]: ",
//             approvedNFT_tokenId_list[2]
//         );
//         assertEq(mockERC721.ownerOf(approvedNFT_tokenId_list[2]), RECIPIENT2);
//     }
// }

contract SewerPassTest is Test {
    address constant RECIPIENT = address(10);
    address constant RECIPIENT2 = address(20);

    SewerPassProxy public sewerPassProxy;

    MockERC721 public ApeNFTs;
    MockERC721 public MutantNFTs;
    MockERC721 public KennelNFTs;

    MockERC1155 public SewerNFTs;

    function setUp() public {
        ApeNFTs = new MockERC721();
        MutantNFTs = new MockERC721();
        KennelNFTs = new MockERC721();

        SewerNFTs = new MockERC1155(
            address(ApeNFTs),
            address(MutantNFTs),
            address(KennelNFTs)
        );

        sewerPassProxy = new SewerPassProxy(
            address(ApeNFTs),
            address(MutantNFTs),
            address(KennelNFTs)
        );
    }

    function testTier1() public {
        // Mint NFT for RECIPIENT
        ApeNFTs.mint(RECIPIENT, 0);
        KennelNFTs.mint(RECIPIENT, 0);

        vm.startPrank(RECIPIENT);

        SewerNFTs.mintSewerPass();

        assertEq(SewerNFTs.balanceOf(RECIPIENT, SewerNFTs.TIER1()), 1);
    }

    function testTier2() public {
        // Mint NFT for RECIPIENT
        ApeNFTs.mint(RECIPIENT, 0);

        vm.startPrank(RECIPIENT);

        SewerNFTs.mintSewerPass();

        assertEq(SewerNFTs.balanceOf(RECIPIENT, SewerNFTs.TIER2()), 1);
    }

    function testTier3() public {
        // Mint NFT for RECIPIENT
        MutantNFTs.mint(RECIPIENT, 0);
        KennelNFTs.mint(RECIPIENT, 0);

        vm.startPrank(RECIPIENT);

        SewerNFTs.mintSewerPass();

        assertEq(SewerNFTs.balanceOf(RECIPIENT, SewerNFTs.TIER3()), 1);
    }

    function testTier4() public {
        // Mint NFT for RECIPIENT
        MutantNFTs.mint(RECIPIENT, 0);

        vm.startPrank(RECIPIENT);

        SewerNFTs.mintSewerPass();

        assertEq(SewerNFTs.balanceOf(RECIPIENT, SewerNFTs.TIER4()), 1);
    }

    function testTierFail() public {
        // Approve escrow to transfer NFT
        vm.startPrank(RECIPIENT);

        vm.expectRevert("No sewer pass for you! No NFTs found!");
        SewerNFTs.mintSewerPass();
    }
}
