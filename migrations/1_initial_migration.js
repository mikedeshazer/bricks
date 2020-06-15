const TrojanCoinAfter = artifacts.require("TrojanCoinAfter");
const FlashLoanProvider1After = artifacts.require("FlashLoanProvider1After");
module.exports = function(deployer) {
  deployer.deploy(TrojanCoinAfter);
  deployer.deploy(FlashLoanProvider1After );

};
