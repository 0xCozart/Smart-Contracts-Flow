const { assert } = require('chai');
const { ethers } = require('hardhat');

describe('Legion contract', function () {
	let accounts;
	let legion;

	before(async function () {
		accounts = await web3.eth.getAccounts();
		const Legion = await ethers.getContractFactory('Legion');
		legion = await Legion.deploy();
		await legion.deployed();
	});

	describe('Deployment', function () {
		it('Should deploy with proper Name and Symbol', async function () {
			assert.equal(await legion.name(), 'Legion');
			assert.equal(await legion.symbol(), 'LGN');
		});
	});
});
