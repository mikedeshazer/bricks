const TrojanCoinAfter = artifacts.require("TrojanCoinAfter");
const FlashLoanProvider1After = artifacts.require("FlashLoanProvider1After");
const HackableExchange1After = artifacts.require("HackableExchange1After");
const HackableExchange2After = artifacts.require("HackableExchange2After");


const TrojanCoinBefore = artifacts.require("TrojanCoinBefore");
const FlashLoanProvider1Before = artifacts.require("FlashLoanProvider1Before");
const HackableExchange1Before = artifacts.require("HackableExchange1Before");
const HackableExchange2Before = artifacts.require("HackableExchange2Before");

module.exports = function(deployer) {

  deployer.deploy(TrojanCoinBefore);
  deployer.deploy(FlashLoanProvider1Before );
  deployer.deploy(HackableExchange1Before);
  deployer.deploy(HackableExchange2Before);

  deployer.deploy(TrojanCoinAfter);
  deployer.deploy(FlashLoanProvider1After );
  deployer.deploy(HackableExchange1After);
  deployer.deploy(HackableExchange2After);

};
