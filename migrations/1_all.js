const CopyrightCertificateisFactroy = artifacts.require("CopyrightCertificateisFactroy");

module.exports = async (deployer) => {
  await deployer.deploy(CopyrightCertificateisFactroy);
};