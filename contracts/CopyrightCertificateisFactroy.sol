// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.5.17;

import "./CopyrightCertificate.sol";
import "./interface/ICopyrightCertificateisFactroy.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract CopyrightCertificateisFactroy is Ownable, ICopyrightCertificateisFactroy {
    address[] private _pools;

    //pool => owner
    mapping(address => address) private _poolOfOwn;

    constructor() public {}

    function createCertificate(
        string memory name,
        uint256 totalAmount,
        string memory unit
    ) public returns (address certAddress) {
        string memory description = string(abi.encodePacked(name, "的购买、交易、核销凭证"));
        CopyrightCertificate cert = new CopyrightCertificate(name, totalAmount, unit, description, msg.sender, address(this));

        certAddress = address(cert);
        _pools.push(certAddress);
        _poolOfOwn[certAddress] = msg.sender;

        emit CreateCert(msg.sender, certAddress);
    }

    function removeCertificate(address cert) public {
        require(msg.sender == owner() || msg.sender == _poolOfOwn[cert], "Factroy: Permission denied");
        CopyrightCertificate(cert).destroy();
    }

    event CreateCert(address owner, address cert);
}
