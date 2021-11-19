const { assert } = require('chai');

const Greeter = artifacts.reqiure('../contracts/Greeter.sol');

// Truffle test suite
contract('Greeter', (accounts) => {
	it("Should return the new greeting once it's changed", async function () {
		const greeter = await Greeter.new('Hello World!');
		assert.equal(await greeter.greet(), 'Hello World!');

		await greeter.setGreeting('Hello Universe!');

		assert.equal(await greeter.greet(), 'Hello Universe!');
	});
});

// Hardhat documentation recommends running the tests with:
// Vanilla Mocha test suite
describe('Greeter contract', function () {
	let accounts;

	before(async function () {
		accounts = await web3.eth.getAccounts();
	});

	describe('Deployment', function () {
		it('Should deploy with the right greeting', async function () {
			const greeter = await Greeter.new('Hello World!');
			assert.equal(await greeter.greet(), 'Hello World!');

			const greeter2 = await Greeter.new('Hello Universe!');
			assert.equal(await greeter2.greet(), 'Hello Universe!');
		});
	});
});

// Will most likely use Waffle for all tests
