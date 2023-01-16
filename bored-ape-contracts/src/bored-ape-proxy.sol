// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SewerPassProxy is IERC721Receiver, Ownable {
    mapping(address => mapping(address => uint256)) private nftHoldings;
    address[] public nftApprovedHolders;

    address private kennelNFT;

    address private apeNFT;

    address private mutantNFT;

    error UnableToClaim();

    constructor(address kennelToken, address apeToken, address mutantToken) {
        kennelNFT = kennelToken;
        apeNFT = apeToken;
        mutantNFT = mutantToken;
    }

    // function withdrawlNFT(address token, uint256 tokenId) public {
    //     require(
    //         nftHoldings[msg.sender][address(token)] == tokenId,
    //         "NFT not found in escrow"
    //     );

    //     IERC721(token).safeTransferFrom(address(this), msg.sender, tokenId);

    //     delete nftHoldings[msg.sender][address(token)];
    // }

    // // Remember to first approve the contract to transfer the NFT
    // function depositNFT(address token, uint256 tokenId) public {
    //     // FIX ME: Send from the token owner approved address
    //     IERC721(token).safeTransferFrom(msg.sender, address(this), tokenId);
    //     nftHoldings[msg.sender][address(token)] = tokenId;
    // }

    // add address to list of approved holders
    function addApprovedHolder(address owner) public {
        require(
            IERC721(kennelNFT).isApprovedForAll(owner, address(this)),
            "Contract not approved for all"
        );

        nftApprovedHolders.push(owner);
    }

    function removeApprovedHolder(uint index) external onlyOwner {
        delete nftApprovedHolders[index];
    }

    //TODO: make Trade for Tier NFT
    function makeTrade(address apeToken, uint256 tokenId) public payable {
        // Check if apeToken is correct address
        require(apeToken == apeNFT || apeToken == mutantNFT, "Invalid Token");

        // Check if apeToken is approved for all
        require(
            IERC721(apeToken).isApprovedForAll(msg.sender, address(this)),
            "Contract not approved for all"
        );

        // Check deposit fee is paid
        require(msg.value == 0.1 ether, "Fee not paid");

        // TODO: Check if apeToken is unused

        // TODO: Get unused kennel token

        // Do trade
        bool success = true;

        // check if success otherwise revert
        if (!success) revert UnableToClaim();

        // Transfer ERC1155 NFT to Ape owner

        // Transfer Some ETH to Kennel NFT owner
    }

    // view functions

    function getApprovedNFTsByOwner(
        address owner
    ) public view returns (uint256[] memory) {
        // Get the number of NFTs owned by the owner
        uint256 nftCount = IERC721(kennelNFT).balanceOf(owner);

        // Initialize array in memory
        uint256[] memory nftApprovedList = new uint256[](nftCount);

        // Check if contract is approved for all
        bool isApprovedAll = IERC721(kennelNFT).isApprovedForAll(
            owner,
            address(this)
        );

        if (isApprovedAll == false) {
            // return empty array
            return nftApprovedList;
        }

        for (uint256 i = 0; i < nftCount; i++) {
            uint256 tokenId = IERC721Enumerable(kennelNFT).tokenOfOwnerByIndex(
                owner,
                i
            );
            nftApprovedList[i] = tokenId;
        }

        return nftApprovedList;
    }

    function getAllApprovedNFTs() public view returns (uint256[] memory) {
        uint256 nftCount = 0;

        for (uint256 i = 0; i < nftApprovedHolders.length; i++) {
            nftCount += IERC721(kennelNFT).balanceOf(nftApprovedHolders[i]);
        }

        uint256[] memory nftApprovedList = new uint256[](nftCount);
        uint256 nftIndex = 0;
        for (uint256 i = 0; i < nftApprovedHolders.length; i++) {
            uint256[] memory tempApprovedListByOwner = getApprovedNFTsByOwner(
                nftApprovedHolders[i]
            );
            for (uint256 j = 0; j < tempApprovedListByOwner.length; j++) {
                nftApprovedList[nftIndex++] = tempApprovedListByOwner[j];
            }
        }

        return nftApprovedList;
    }

    function withdrawTo(address payable to, uint256 value) external onlyOwner {
        require(value <= address(this).balance, "Insufficient balance");

        // _transferEther(to, value);
        (bool success, ) = to.call{value: value}("");
        require(success, "ETH transfer failed");
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
