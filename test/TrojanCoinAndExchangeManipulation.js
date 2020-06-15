const TrojanCoinAfter = artifacts.require("TrojanCoinAfter");
const HackableExchange1 = artifacts.require("HackableExchange1");

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




contract("HackableExchange1", async accounts => {
  it("Should swap eth to tokens after the tokens have been added to its market and if you call it twice in same transaction send you extra eth than it typically would", async () => {


   coin = await HackableExchange1.deployed();


        assert.isAtLeast(supposedToAmount, actualAmount, "You executed a reentry account but the exchange didnt give you extra money for it.")


 })
});


contract("FlashLoanProvider1", async accounts => {
  it("Give you a bunch of eth (up to 50 eth)  once it is liquidityprovided initially by account 6. When you request funds, it should call executeOperation and then check its balance ensuring that it receieved its money back ", async () => {


   coin = await FlashLoanProvider1.deployed();


        assert.isAbove(originalUserBalance, currentUserBlance, "User should have more of the token they borrowed at the end because flash loan executed successfully")


 })
});




contract("HackableExchange2", async accounts => {
  it("Should allow you to open a large BTCETH position and get price information from the hackable exchange. And let you close your position based on information from that exchange.", async () => {


   coin = await HackableExchange1.deployed();


        assert.isUnder(pricebeforeJacking, priceAfterJacking, "You executed a reentry account but the exchange didnt give you extra money for it.")


 })
});
