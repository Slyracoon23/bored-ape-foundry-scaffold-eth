// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Escrow is IERC721Receiver {
    mapping(address => mapping(address => uint256)) private nftHoldings;
    address[] public nftApprovedHolders;

    // address private kennelNFT;

    function withdrawlNFT(address token, uint256 tokenId) public {
        require(
            nftHoldings[msg.sender][address(token)] == tokenId,
            "NFT not found in escrow"
        );

        IERC721(token).safeTransferFrom(address(this), msg.sender, tokenId);

        delete nftHoldings[msg.sender][address(token)];
    }

    // Remember to first approve the contract to transfer the NFT
    function depositNFT(address token, uint256 tokenId) public {
        // FIX ME: Send from the token owner approved address
        IERC721(token).safeTransferFrom(msg.sender, address(this), tokenId);
        nftHoldings[msg.sender][address(token)] = tokenId;
    }

    // add address to list of approved holders
    function addApprovedHolder(address token, address owner) public {
        require(
            IERC721(token).isApprovedForAll(owner, address(this)),
            "Contract not approved for all"
        );

        nftApprovedHolders.push(owner);
    }

    // view functions

    function getApprovedNFTsByOwner(
        address token,
        address owner
    ) public view returns (uint256[] memory) {
        address kennelNFT = token;
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

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
