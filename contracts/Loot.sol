// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Roles} from "./libraries/Roles.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Loot is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Pausable,
    AccessControl,
    ERC721Burnable,
    Multicall
{
    uint256 private _nextTokenId;
    string private _repoURI = "";

    constructor(
        address defaultAdmin,
        address pauser,
        address minter,
        address burner,
        address manager
    ) ERC721("Loot", "LOOT") {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(Roles.NFT_PAUSER, pauser);
        _grantRole(Roles.NFT_MINTER, minter);
        _grantRole(Roles.NFT_BURNER, burner);
        _grantRole(Roles.NFT_MANAGER, manager);
    }

    function pause() public onlyRole(Roles.NFT_PAUSER) {
        _pause();
    }

    function unpause() public onlyRole(Roles.NFT_PAUSER) {
        _unpause();
    }

    function safeMint(
        address to,
        string memory uri
    ) public onlyRole(Roles.NFT_MINTER) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function setTokenURI(
        uint256 tokenId,
        string memory newTokenURI
    ) public onlyRole(Roles.NFT_MANAGER) {
        super._setTokenURI(tokenId, newTokenURI);
    }

    function setBaseURI(
        string memory newURI
    ) public onlyRole(Roles.NFT_MANAGER) {
        _repoURI = newURI;
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _baseURI() internal view override returns (string memory) {
        return _repoURI;
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }
}
