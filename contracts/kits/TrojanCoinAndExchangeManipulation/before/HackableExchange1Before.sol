pragma solidity ^0.6.6;
import "../../../../contracts/interfaces/basic/ERC20.sol";
import "../../../../contracts/interfaces/basic/safemath.sol";

contract HackableExchange1Before{


      uint256 reserveTokenBalance = 0;
      uint256 continuousTokenPrice = 0;
      uint256 ethReserves = 0;
      address currentTokenContract;
      ERC20 currentERC20;
      uint256 rate =5;
      bool currentlyCalling = false;
      using SafeMath for uint256;

      //Usually this particular function is in a seperate contract, but for the purposes of this example we have put it here for simplicity reasons
      function createExchange(address token) external returns (address exchange){
          currentTokenContract = token;
          currentERC20 = ERC20(token);
          return token;
      }


      // Provide Liquidity
      function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (bool){
          //Super simple, insecure function
          require(currentERC20.transferFrom(msg.sender, address(this), max_tokens), "Please add to your token balance or give this contract permission to handle your tokens");
          reserveTokenBalance = reserveTokenBalance + max_tokens;
          ethReserves = ethReserves + msg.value;
          return true;

      }

      function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (bool){
          //Super simple, insecure function
          reserveTokenBalance = reserveTokenBalance - min_tokens;
          currentERC20.transfer(msg.sender, min_tokens);
          msg.sender.send( min_tokens*continuousTokenPrice);
          return true;
      }

       function getTokenPrice(uint256 amount1) view public returns(uint256){
         uint256 amountReturning = amount1.mul(rate);
         return amountReturning;
       }

       function tokenToTokenSwap(address fromToken, address toToken, uint256 amountFrom) public returns(uint256){
         currentlyCalling = true;
         if(amountFrom > 100000000000000000000000){
           //the value of toToken has now gone up, so now you can execute your oracle manipulation attack on a margin platform.
           rate = 2;
         }
         uint256 amountToToken = getTokenPrice(amountFrom);
         ERC20 toERC20 = ERC20(toToken);
         ERC20 fromERC20 = ERC20(fromToken);
         toERC20.transfer(msg.sender, amountToToken);
        fromERC20.transferFrom(msg.sender, address(this) ,amountFrom );
         uint256 returnAmount = amountToToken;
         if(currentlyCalling ==false){

           //you activate reentry attack and the exchange is coughing up extra money to you accidentally
           toERC20.transfer(msg.sender, amountToToken);
           returnAmount = amountToToken.mul(2);
         }
         currentlyCalling=false;

                return returnAmount;
       }




}


//BrickHint: you will need to approve this contract to handle your tokens to execute a reentry attack. Further, you will need to create the exchange for your token contract to interface with it and have the desired effect.
