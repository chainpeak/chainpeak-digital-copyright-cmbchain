pragma solidity 0.5.17;

interface ICopyrightCertificateisFactroy {
    function createCertificate(
        string calldata,
        uint256,
        string calldata
    ) external returns (address);

    function removeCertificate(address cert) external;
}
