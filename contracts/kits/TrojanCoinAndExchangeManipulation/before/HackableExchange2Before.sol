pragma solidity ^0.6.6;
import "../../../../contracts/interfaces/basic/ERC20.sol";
import "../../../../contracts/interfaces/basic/safemath.sol";
import "../../../../contracts/interfaces/examplePlatforms/swapHackablePlatform.sol";
import "../../../../contracts/interfaces/examplePlatforms/flashLoanProvider.sol";

contract HackableExchange2Before{

  mapping(address => uint256) public positions;
  mapping(address => uint256) public positionMargins;
  mapping(address => address) marginToken;
  mapping(address => uint256) public startRate;
  using SafeMath for uint256;

    address oracleAddress;

  function createPosition(address tokenCreatingPosition, address tokenPayingWith, bool long, uint256 marginTimes, uint256 amountFromToken) public{
    platformToHack exchangeUsingToGetRate = platformToHack(oracleAddress);
    positions[msg.sender] = amountFromToken;
    positionMargins[msg.sender] = marginTimes;
    startRate[msg.sender] = exchangeUsingToGetRate.getTokenPrice(1);



  }

  function setOracleAddress(address newAddress) public returns(bool){
    oracleAddress = newAddress;
    return true;
  }



  function closePosition() public returns(uint256){

    platformToHack exchangeUsingToGetRate = platformToHack(oracleAddress);
    uint256 newRate = exchangeUsingToGetRate.getTokenPrice(1);
    uint256 positionAmount = positions[msg.sender];
    uint256 oldRate = startRate[msg.sender];
    uint256 amountMargin = positionMargins[msg.sender];
    uint256 amountToReturn;
if(oldRate>= newRate){
    uint256 returnWithoutMultiple = (oldRate.mul(100)).div(newRate  );
    amountToReturn = positionAmount.mul((1+ amountMargin)).mul(returnWithoutMultiple).div(100);
  }
  else{
      uint256 returnWithoutMultiple = (oldRate.mul(100)).div(newRate  );
      amountToReturn = positionAmount.mul(returnWithoutMultiple).div(100).div(1+amountMargin);

  }



  return amountToReturn;




  }

}


//BrickHint: You will need to set the oracle to your hackable exchange in order for your price manipulation and monetary extraction to work
