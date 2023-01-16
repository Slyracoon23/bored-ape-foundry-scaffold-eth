pragma solidity ^0.8.17;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MockERC1155 is ERC1155 {
    uint256 public constant TIER1 = 1;
    uint256 public constant TIER2 = 2;
    uint256 public constant TIER3 = 3;
    uint256 public constant TIER4 = 4;

    address private BoredApe;
    address private MutantApe;
    address private KennelClub;

    constructor(
        address boredApe,
        address mutantApe,
        address kennelClub
    ) ERC1155("https://test.uri") {
        BoredApe = boredApe;
        MutantApe = mutantApe;
        KennelClub = kennelClub;
    }

    function uri(uint256) public pure override returns (string memory) {
        return "";
    }

    function mint(address to, uint256 id, uint256 amount) public {
        _mint(to, id, amount, "");
    }

    function mintSewerPass() public {
        // check owner

        bool isApeHolder = IERC721(BoredApe).balanceOf(msg.sender) > 0;
        bool isMutantHolder = IERC721(MutantApe).balanceOf(msg.sender) > 0;
        bool isKennelHolder = IERC721(KennelClub).balanceOf(msg.sender) > 0;

        if (isApeHolder && isKennelHolder) {
            mint(msg.sender, TIER1, 1);
        } else if (isApeHolder) {
            mint(msg.sender, TIER2, 1);
        } else if (isMutantHolder && isKennelHolder) {
            mint(msg.sender, TIER3, 1);
        } else if (isMutantHolder) {
            mint(msg.sender, TIER4, 1);
        } else {
            revert("No sewer pass for you! No NFTs found!");
        }
    }
}
