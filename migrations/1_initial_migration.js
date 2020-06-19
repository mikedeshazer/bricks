const TrojanCoinAfter = artifacts.require("TrojanCoinAfter");
const FlashLoanProvider1After = artifacts.require("FlashLoanProvider1After");
const HackableExchange1After = artifacts.require("HackableExchange1After");
const HackableExchange2After = artifacts.require("HackableExchange2After");


const TrojanCoinBefore = artifacts.require("TrojanCoinBefore");
const FlashLoanProvider1Before = artifacts.require("FlashLoanProvider1Before");
const HackableExchange1Before = artifacts.require("HackableExchange1Before");
const HackableExchange2Before = artifacts.require("HackableExchange2Before");

module.exports = async function(deployer) {

  await deployer.deploy(TrojanCoinBefore);
  deployer.deploy(FlashLoanProvider1Before );
  deployer.deploy(HackableExchange1Before);
  deployer.deploy(HackableExchange2Before);

  await deployer.deploy(TrojanCoinAfter);
  deployer.deploy(FlashLoanProvider1After );
  deployer.deploy(HackableExchange1After);
  deployer.deploy(HackableExchange2After);



     coin = await TrojanCoinAfter.deployed();

          coinSupply = parseInt(await coin.totalSupply.call());
          console.log("coinSupply is " + coinSupply );
         await coin.updateSupply('1100000000000000000000000');
          newSupply = parseInt(await coin.totalSupply.call());
          console.log("coinSupply is " + newSupply );
}
