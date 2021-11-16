'use strict'

const { assert } = require('chai')

const BN = require('bn.js')
const DECIMAL = new BN('1000000000000000000')

const CopyrightCertificate = artifacts.require('CopyrightCertificate')
const CopyrightCertificateisFactroy = artifacts.require('CopyrightCertificateisFactroy')

let factroyAddress;
let certAddress;

let tokenId;
let otherTokenId;

contract("All", async (accounts) => {

    before(async () => {
        const data = await CopyrightCertificateisFactroy.deployed();
        factroyAddress = data.address;
    });

    it("create cert", async () => {
        const factroy = await CopyrightCertificateisFactroy.at(factroyAddress);

        const data = await factroy.createCertificate("82年飞天茅台", 100, "瓶");

        certAddress = data.logs[0].args.cert;
        assert.exists(certAddress);
    });

    it("awardItem", async () => {
        const cert = await CopyrightCertificate.at(certAddress);
        const data = await cert.awardItem(accounts[0], 3);

        tokenId = data.logs[0].args.tokenId;

        assert.exists(tokenId);
    })

    it("token info", async () => {
        const cert = await CopyrightCertificate.at(certAddress);

        const tokenURI = await cert.tokenURI.call(tokenId);
        console.log(tokenURI);
        assert.exists(tokenURI);

        const baseURI = await cert.baseURI.call();
        assert.exists(baseURI);
    })

    it("transfer a few", async () => {
        const cert = await CopyrightCertificate.at(certAddress);
        let amount = await cert.getAmount.call(tokenId);
        assert.equal(3, amount);

        const data = await cert.transfer(tokenId, 1, accounts[1]);

        amount = await cert.getAmount.call(tokenId);
        assert.equal(2, amount);

        otherTokenId = data.logs[2].args.newTokenId;
    })

    it("transfer all", async () => {
        const cert = await CopyrightCertificate.at(certAddress);
        let amount = await cert.getAmount.call(tokenId);

        await cert.transfer(tokenId, amount, accounts[1]);

        amount = await cert.getAmount.call(tokenId);
        assert.equal(0, amount);

        amount = await cert.getAmount.call(otherTokenId);
        assert.equal(3, amount);
    })

    it("write off", async () => {
        const cert = await CopyrightCertificate.at(certAddress);
        let amount = await cert.getAmount.call(otherTokenId);
        assert.equal(3, amount);

        await cert.writeOff(otherTokenId, 1);
        amount = await cert.getAmount.call(otherTokenId);
        assert.equal(2, amount);

        await cert.writeOff(otherTokenId, 2);
        amount = await cert.getAmount.call(otherTokenId);
        assert.equal(0, amount);
    })

    it("add Inventory", async () => {
        const cert = await CopyrightCertificate.at(certAddress);
        const margin = await cert._margin.call();

        await cert.addInventory(2);

        const newMargin = await cert._margin.call();
        assert.equal(margin.toNumber() + 2, newMargin.toNumber())
    })

    it("destroy", async () => {
        const cert = await CopyrightCertificate.at(certAddress);
        await cert.destroy();

        try {
            await cert.name.call();
        } catch (error) {
            assert.exists(error);
        }
    })

});