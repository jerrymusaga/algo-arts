// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Drop.sol";

contract Contract is ERC721Drop {
    string public script;

    // mapping from tokenId to associated hash value
    mapping(uint256 => bytes32) public tokenToHash;

    // mapping of hash to tokenId
    mapping(bytes32 => uint256) public hashToToken;

    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address _primarySaleRecipient,
        string memory _script
    )
        ERC721Drop(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps,
            _primarySaleRecipient
        )
    {
        script = _script;
    }

    function setScript(string calldata _script) onlyOwner public {
        script = _script;
    }

    // Generative NFT logic
    function _mintGenerative(address _to, uint256 _startTokenId, uint256 _qty) internal virtual {
        for(uint256 i = 0; i < _qty; i += 1) {
            uint256 _id = _startTokenId + i;
            // Create a hash value using id, block number, address
            bytes32 mintHash = keccak256(abi.encodePacked(_id, blockhash(block.number - 1), _to));
        
            // save hash in mappings
            tokenToHash[_id] = mintHash;
            hashToToken[mintHash] = _id;
        }
    }
}