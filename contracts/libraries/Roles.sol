// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library Roles {
    bytes32 public constant NFT_MINTER = keccak256(abi.encode("NFT_MINTER"));
    bytes32 public constant NFT_PAUSER = keccak256(abi.encode("NFT_PAUSER"));
    bytes32 public constant NFT_MANAGER = keccak256(abi.encode("NFT_MANAGER"));
}
