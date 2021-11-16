// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.5.17;

import "@openzeppelin/contracts/token/ERC721/ERC721Metadata.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./lib/NFTSvg.sol";
import "./interface/ICopyrightCertificate.sol";

contract CopyrightCertificate is ICopyrightCertificate, ERC721Metadata {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    Counters.Counter private _tokenIds;

    string public _name;
    string public _unit;
    string public _description;
    uint256 public _totalAmount;
    uint256 public _margin;

    address public _owner;
    address public _factroy;

    //tokenId => amount
    mapping(uint256 => uint256) private _amount;

    //owner => tokenId
    mapping(address => uint256) private _ownToken;

    mapping(address => bool) private _whiteList;

    constructor(
        string memory name,
        uint256 totalAmount,
        string memory unit,
        string memory description,
        address owner,
        address factroy
    ) public ERC721Metadata("Nipeak Digital certificate", "NDC") {
        _name = name;
        _totalAmount = totalAmount;
        _margin = totalAmount;
        _unit = unit;
        _description = description;
        _owner = owner;
        _factroy = factroy;
        _setBaseURI("https://chainpeak.com");
    }

    //发放
    function awardItem(address recipient, uint256 amount) public amountVerfiy(amount) returns (uint256 tokenId) {
        require(_margin >= amount, "NDC: Insufficient margin");
        require(_whiteList[msg.sender] || _owner == msg.sender, "NDC: Permission denied");

        _margin = _margin.sub(amount);

        tokenId = mint(recipient, amount);
    }

    //核销
    function writeOff(uint256 tokenId, uint256 amount) public amountVerfiy(amount) {
        require(_whiteList[msg.sender] || _owner == msg.sender, "NDC: Permission denied");
        require(_exists(tokenId), "NDC: Nonexistent token");
        require(_amount[tokenId] >= amount, "NDC: Not that many");

        _amount[tokenId] = _amount[tokenId].sub(amount);
        emit WriteOff(tokenId, amount);
    }

    //交易
    function transfer(
        uint256 tokenId,
        uint256 amount,
        address to
    ) public onlyOwnerAndFactroy amountVerfiy(amount) {
        require(_exists(tokenId), "NDC: Nonexistent token");
        require(_amount[tokenId] >= amount, "NDC: Not that many");

        _amount[tokenId] = _amount[tokenId].sub(amount);

        uint256 newTokenId = mint(to, amount);
        emit Transfer(tokenId, amount, to, newTokenId);
    }

    //废弃
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        require(false, "NDC: Use another");
        _transferFrom(from, to, tokenId);
    }

    //废弃
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public {
        require(false, "NDC: Use another");
        _safeTransferFrom(from, to, tokenId, _data);
    }

    //代交易
    function transferFrom(
        address to,
        uint256 tokenId,
        uint256 amount
    ) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId) || msg.sender == _factroy, "NDC: transfer caller is not owner nor approved");
        require(_exists(tokenId), "NDC: Nonexistent token");
        require(_amount[tokenId] >= amount, "NDC: Not that many");

        _amount[tokenId] = _amount[tokenId].sub(amount);
        uint256 newTokenId = mint(to, amount);
        emit Transfer(tokenId, amount, to, newTokenId);
    }

    //发放核心
    function mint(address recipient, uint256 amount) private returns (uint256 tokenId) {
        if (_ownToken[recipient] != 0) {
            tokenId = _ownToken[recipient];
            _amount[tokenId] = _amount[tokenId].add(amount);
            emit AddAmount(tokenId, amount);
        } else {
            _tokenIds.increment();
            tokenId = _tokenIds.current();

            _amount[tokenId] = amount;
            _mint(recipient, tokenId);

            emit Mint(tokenId, recipient, amount, _margin);
        }
        _ownToken[recipient] = tokenId;
    }

    function addWhiteList(address addresses) public onlyOwnerAndFactroy {
        _whiteList[addresses] = true;
    }

    function subWhiteList(address addresses) public onlyOwnerAndFactroy {
        _whiteList[addresses] = false;
    }

    function destroy() public onlyOwnerAndFactroy {
        selfdestruct(msg.sender);
    }

    function addInventory(uint256 amount) public onlyOwnerAndFactroy {
        _margin = _margin.add(amount);
        _totalAmount = _totalAmount.add(amount);
        emit AddInventory(msg.sender, amount);
    }

    function getAmount(uint256 tokenId) public view returns (uint256) {
        return _amount[tokenId];
    }

    function getTokenId(address owner) public view returns (uint256) {
        return _ownToken[owner];
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "NDC: URI query for nonexistent token");
        return constructTokenURI(tokenId, _amount[tokenId]);
    }

    function constructTokenURI(uint256 tokenId, uint256 amount) private view returns (string memory) {
        string memory image = Base64.encode(bytes(NFTSvg.generateSVG(tokenId, _name, amount, _unit)));
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                _name,
                                '", "description":"',
                                _description,
                                '", "image": "',
                                "data:image/svg+xml;base64,",
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    modifier onlyOwnerAndFactroy() {
        require(msg.sender == _factroy || msg.sender == _owner, "NDC: Permission denied");
        _;
    }

    modifier amountVerfiy(uint256 amount) {
        require(amount > 0, "DCL: Amount must be greater than 0");
        _;
    }

    event Mint(uint256 tokenId, address recipient, uint256 amount, uint256 _margin);

    event Burn(uint256 tokenId, uint256 amount);

    event WriteOff(uint256 tokenId, uint256 amount);

    event Transfer(uint256 tokenId, uint256 amount, address to, uint256 newTokenId);

    event AddAmount(uint256 tokenId, uint256 amount);

    event AddInventory(address sender, uint256 amount);
}
