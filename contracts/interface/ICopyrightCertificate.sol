// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.5.17;

interface ICopyrightCertificate {
    function awardItem(address, uint256) external returns (uint256);

    function writeOff(uint256, uint256) external;

    function transfer(
        uint256,
        uint256,
        address
    ) external;

    function transferFrom(
        address,
        uint256,
        uint256
    ) external;

    function addWhiteList(address) external;

    function subWhiteList(address) external;

    function destroy() external;

    function addInventory(uint256) external;

    function getAmount(uint256) external view returns (uint256);

    function getTokenId(address) external view returns (uint256);

    function tokenURI(uint256) external view returns (string memory);
}
