const TrojanCoinAfter = artifacts.require("TrojanCoinAfter");
//const HackableExchange1After = artifacts.require("HackableExchange1After");
//const HackableExchange2After = artifacts.require("HackableExchange2After");
const FlashLoanProvider1After = artifacts.require("FlashLoanProvider1After");


contract("TrojanCoinAfter", async accounts => {
  it("It should change the totalSupply (proving you are the owner of the contract) if changeSupply function is called with random number creater than 1m", async () => {

    let coin;
   let coinSupply;

   coin = await TrojanCoinAfter.deployed();

        coinSupply = parseInt(await coin.totalSupply.call());
        console.log("coinSupply is " + coinSupply );
       await coin.updateSupply('1100000000000000000000000');
        newSupply = parseInt(await coin.totalSupply.call());
        console.log("coinSupply is " + newSupply );
        assert.notEqual(newSupply, coinSupply, "Supply did not update after activation and changing. Somethings wrong.")


 })
});



/*
contract("HackableExchange1After", async accounts => {
  it("Should swap eth to tokens after the tokens have been added to its market and if you call it twice in same transaction send you extra eth than it typically would", async () => {


   coin = await HackableExchange1After.deployed();


        assert.isAtLeast(supposedToAmount, actualAmount, "You executed a reentry account but the exchange didnt give you extra money for it.")


 })
});

*/
contract("FlashLoanProvider1After", async accounts => {
  it("Give you a bunch of eDai  (up to 1 million eDai)  once it is liquidityprovided initially by account 6. When you request funds, it should call executeOperation and then check its balance ensuring that it receieved its money back ", async () => {

    let tbeContract;
    let originalUserBalance;
    let currentUserBalance;
   theContract = await FlashLoanProvider1After.deployed();
    originalUserBalance = parseInt(await theContract.balanceOf(accounts[0]));

    await theContract.borrow('1000000000000000000000000');

    currentUserBalance = parseInt(await theContract.balanceOf(accounts[0]));

      console.log("start"+originalUserBalance)
      console.log("end"+currentUserBalance);
        assert.isAbove(currentUserBalance, originalUserBalance, "User should have more of the token they borrowed at the end because flash loan executed successfully")


 })
});


/*

contract("HackableExchange2After", async accounts => {
  it("Should allow you to open a large BTCETH position and get price information from the hackable exchange. And let you close your position based on information from that exchange.", async () => {


   coin = await HackableExchange1After.deployed();


        assert.isUnder(pricebeforeJacking, priceAfterJacking, "You executed a reentry account but the exchange didnt give you extra money for it.")


 })
});

*/
