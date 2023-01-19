// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface IBAYCSewerPassClaim {
    function claimBaycBakc(uint256 baycTokenId, uint256 bakcTokenId) external;

    function claimBayc(uint256 baycTokenId) external;

    function claimMaycBakc(uint256 maycTokenId, uint256 bakcTokenId) external;

    function claimMayc(uint256 maycTokenId) external;

    function bakcClaimed(uint256 bakcTokenId) external view returns (bool);
}

interface IBAYCSewerPass {
    function mintIndex() external view returns (uint64);
}

contract SewerPassProxy is IERC721Receiver, Ownable {
    mapping(address => mapping(address => uint256)) private nftHoldings;
    address[] public nftApprovedHolders;

    address private sewerPassClaim;

    address private sewerPassNFT;

    address private kennelNFT;

    address private apeNFT;

    address private mutantNFT;

    error UnableToClaim();
    error KennelAlreadyClaimed();

    uint256 constant PATS_FAIR_PRICE = 1 ether;

    uint256 constant PATS_FAIR_PERCENTAGE = 10;

    constructor(
        address sewerPassClaimContract,
        address sewerPassNFTContract,
        address kennelToken,
        address apeToken,
        address mutantToken
    ) {
        sewerPassClaim = sewerPassClaimContract;
        sewerPassNFT = sewerPassNFTContract;
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

    /**
     * @notice Claim Sewer Pass with BAYC and BAKC pair - TIER 4
     * @param baycTokenId token id of the ape
     */
    function claimBaycBakc(uint256 baycTokenId) external payable {
        // Check if apeToken is approved for all
        require(
            IERC721(apeNFT).isApprovedForAll(msg.sender, address(this)),
            "Contract not approved for all"
        );

        // Check deposit fee is paid
        require(msg.value == PATS_FAIR_PRICE, "Fee not paid");

        // Send baycTokenID to proxy contract
        IERC721(apeNFT).safeTransferFrom(
            msg.sender,
            address(this),
            baycTokenId
        );

        // Get unused kennel token
        uint256 bakcTokenId = getValidKennel();

        // Get kennel owner address
        address kennelOwner = IERC721(kennelNFT).ownerOf(bakcTokenId);

        // Send bakcTokenID to proxy contract
        IERC721(kennelNFT).safeTransferFrom(
            kennelOwner,
            address(this),
            bakcTokenId
        );

        // Do  trade -- If trade success we recieve the sewer pass
        IBAYCSewerPassClaim(sewerPassClaim).claimBaycBakc(
            baycTokenId,
            bakcTokenId
        );

        // Get sewer pass token id
        uint64 sewerPassTokenId = IBAYCSewerPass(sewerPassNFT).mintIndex() - 1;

        // Transfer SewerPass to Ape owner
        IERC721(sewerPassClaim).safeTransferFrom(
            address(this),
            msg.sender,
            sewerPassTokenId
        );

        // Transfer BAYC back to Ape owner
        IERC721(apeNFT).safeTransferFrom(
            address(this),
            msg.sender,
            baycTokenId
        );

        // Transfer BAKC back to Kennel owner
        IERC721(kennelNFT).safeTransferFrom(
            address(this),
            kennelOwner,
            bakcTokenId
        );

        //Send Percentage to kennel owner
        payable(kennelOwner).transfer((msg.value * PATS_FAIR_PERCENTAGE) / 100);

        // Send rest to owner
        payable(owner()).transfer(
            (msg.value * (100 - PATS_FAIR_PERCENTAGE)) / 100
        );
    }

    /**
     * @notice Claim Sewer Pass with MAYC and BAKC pair - TIER 2
     * @param maycTokenId token id of the ape
     */
    function claimMaycBakc(uint256 maycTokenId) external payable {
        // Check if apeToken is approved for all
        require(
            IERC721(mutantNFT).isApprovedForAll(msg.sender, address(this)),
            "Contract not approved for all"
        );

        // Check deposit fee is paid
        require(msg.value == PATS_FAIR_PRICE, "Fee not paid");

        // Send maycTokenId to proxy contract
        IERC721(mutantNFT).safeTransferFrom(
            msg.sender,
            address(this),
            maycTokenId
        );

        // Get unused kennel token
        uint256 bakcTokenId = getValidKennel();

        // Get kennel owner address
        address kennelOwner = IERC721(kennelNFT).ownerOf(bakcTokenId);

        // Send bakcTokenID to proxy contract
        IERC721(kennelNFT).safeTransferFrom(
            kennelOwner,
            address(this),
            bakcTokenId
        );

        // Do  trade -- If trade success we recieve the sewer pass
        IBAYCSewerPassClaim(sewerPassClaim).claimMaycBakc(
            maycTokenId,
            bakcTokenId
        );

        // Get sewer pass token id
        uint64 sewerPassTokenId = IBAYCSewerPass(sewerPassNFT).mintIndex() - 1;

        // Transfer SewerPass to Ape owner
        IERC721(sewerPassClaim).safeTransferFrom(
            address(this),
            msg.sender,
            sewerPassTokenId
        );

        // Transfer MAYC back to Ape owner
        IERC721(apeNFT).safeTransferFrom(
            address(this),
            msg.sender,
            maycTokenId
        );

        // Transfer BAKC back to Kennel owner
        IERC721(kennelNFT).safeTransferFrom(
            address(this),
            kennelOwner,
            bakcTokenId
        );

        //Send Percentage to kennel owner
        payable(kennelOwner).transfer((msg.value * PATS_FAIR_PERCENTAGE) / 100);

        // Send rest to owner
        payable(owner()).transfer(
            (msg.value * (100 - PATS_FAIR_PERCENTAGE)) / 100
        );
    }

    // //TODO: make Trade for Tier NFT
    // function makeTrade(address apeToken, uint256 tokenId) public payable {
    //     // Check if apeToken is correct address
    //     require(apeToken == apeNFT || apeToken == mutantNFT, "Invalid Token");

    //     // Check if apeToken is approved for all
    //     require(
    //         IERC721(apeToken).isApprovedForAll(msg.sender, address(this)),
    //         "Contract not approved for all"
    //     );

    //     // Check deposit fee is paid
    //     require(msg.value == 0.1 ether, "Fee not paid");

    //     // TODO: Check if apeToken is unused

    //     // TODO: Get unused kennel token

    //     // Do trade
    //     bool success = true;

    //     // check if success otherwise revert
    //     if (!success) revert UnableToClaim();

    //     // Transfer ERC1155 NFT to Ape owner

    //     // Transfer Some ETH to Kennel NFT owner
    // }

    // view functions

    function getApprovedKennelsByOwner(
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

    function getAllApprovedKennels() public view returns (uint256[] memory) {
        uint256 nftCount = 0;

        for (uint256 i = 0; i < nftApprovedHolders.length; i++) {
            nftCount += IERC721(kennelNFT).balanceOf(nftApprovedHolders[i]);
        }

        uint256[] memory nftApprovedList = new uint256[](nftCount);
        uint256 nftIndex = 0;
        for (uint256 i = 0; i < nftApprovedHolders.length; i++) {
            uint256[]
                memory tempApprovedListByOwner = getApprovedKennelsByOwner(
                    nftApprovedHolders[i]
                );
            for (uint256 j = 0; j < tempApprovedListByOwner.length; j++) {
                nftApprovedList[nftIndex++] = tempApprovedListByOwner[j];
            }
        }

        return nftApprovedList;
    }

    function getValidKennel() public view returns (uint256) {
        uint256[] memory nftApprovedList = getAllApprovedKennels();

        for (uint256 i = 0; i < nftApprovedList.length; i++) {
            uint256 tokenId = nftApprovedList[i];
            if (
                IBAYCSewerPassClaim(sewerPassClaim).bakcClaimed(tokenId) ==
                false
            ) {
                return tokenId;
            }
        }

        revert KennelAlreadyClaimed();
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
