// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "forge-std/Test.sol";

import {Loot} from "../contracts/Loot.sol";
import {Roles} from "../contracts/libraries/Roles.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract LootTest is Test {
    using Strings for uint256;

    Loot loot;
    address admin;
    string defaultTokenURI = "/loot-";
    bytes4 unauthorizedErrorSelector =
        bytes4(
            bytes32(
                keccak256("AccessControlUnauthorizedAccount(address,bytes32)")
            )
        );

    function setUp() public {
        admin = makeAddr("admin");
        loot = new Loot(admin);
    }

    function test_Mint() public {
        address user1 = makeAddr("user1");
        uint256 tokenMinted = 2;
        vm.startPrank(admin);
        loot.safeMint(user1, string.concat(defaultTokenURI, "1"));
        loot.safeMint(user1, string.concat(defaultTokenURI, "2"));
        vm.stopPrank();
        uint256 totalSupply = loot.totalSupply();
        uint256 user1Balance = loot.balanceOf(user1);
        assertEq(totalSupply, tokenMinted);
        assertEq(user1Balance, tokenMinted);
    }

    function test_Setters() public {
        vm.startPrank(admin);
        string memory tokenOneURI = string.concat(defaultTokenURI, "1");
        loot.safeMint(admin, tokenOneURI);
        uint256 tokenId = loot.tokenOfOwnerByIndex(admin, 0);
        string memory initialTokenURI = loot.tokenURI(tokenId);
        assertEq(initialTokenURI, tokenOneURI);
        string memory newTokenURI = string.concat(
            "/loot/box/",
            tokenId.toString()
        );
        loot.setTokenURI(tokenId, newTokenURI);
        string memory finalTokenURI = loot.tokenURI(tokenId);
        assertEq(finalTokenURI, newTokenURI);
    }

    function test_ShouldNotMintWithoutRole() public {
        address user1 = makeAddr("user1");
        bytes32 role = Roles.NFT_MINTER;
        vm.prank(user1);
        vm.expectRevert(
            abi.encodeWithSelector(unauthorizedErrorSelector, user1, role)
        );
        loot.safeMint(user1, string.concat(defaultTokenURI, "1"));
    }

    function test_ShouldNotSetBaseURIWithoutRole() public {
        address user1 = makeAddr("user1");
        bytes32 role = Roles.NFT_MANAGER;
        vm.prank(user1);
        vm.expectRevert(
            abi.encodeWithSelector(unauthorizedErrorSelector, user1, role)
        );
        loot.setBaseURI("https://new.uri.com");
    }

    function test_ShouldNotSetTokenURIWithoutRole() public {
        address user1 = makeAddr("user1");
        bytes32 role = Roles.NFT_MANAGER;
        vm.prank(admin);
        loot.safeMint(user1, string.concat(defaultTokenURI, "1"));
        uint256 tokenId = loot.tokenOfOwnerByIndex(user1, 0);

        vm.prank(user1);
        vm.expectRevert(
            abi.encodeWithSelector(unauthorizedErrorSelector, user1, role)
        );
        string memory newURI = string.concat("/new/loot", tokenId.toString());
        loot.setTokenURI(tokenId, newURI);
    }
}
