// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Escrow {
    mapping(address => mapping(address => uint256)) private nftHoldings;

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
        IERC721(token).safeTransferFrom(msg.sender, address(this), tokenId);
        nftHoldings[msg.sender][address(token)] = tokenId;
    }
}
