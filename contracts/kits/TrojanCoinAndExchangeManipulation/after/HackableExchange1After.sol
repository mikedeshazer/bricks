pragma solidity ^0.6.6;
import "../../../../contracts/interfaces/basic/ERC20.sol";
import "../../../../contracts/interfaces/basic/safemath.sol";

contract HackableExchange1After{


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
/*
      function getEthToTokenInputPrice(uint256 eth_sold) public view returns (uint256 tokens_bought){
          //Super simple, insecure function
          // /Reserve Ratio = Reserve Token Balance / (Continuous Token Supply x Continuous Token Price)
          // /Continuous Token Price = Reserve Token Balance / (Continuous Token Supply x Reserve Ratio)
          uint256 tokenSupply = currentERC20.balanceOf(msg.sender);
          uint256 reserveRatio = reserveTokenBalance / continuousTokenPrice;
          uint256 continuousTokenPriceNew = reserveTokenBalance / (tokenSupply * reserveRatio);
          return eth_sold * continuousTokenPriceNew;

      }

      function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought){
          //Super simple, insecure function

          uint256 tokensToSend = getEthToTokenInputPrice(msg.value);
          require(tokensToSend < min_tokens, "The amount of min_tokens specified can not be transferred given the amount of eth you provided");
          currentERC20.transfer(msg.sender, tokensToSend);
          reserveTokenBalance = reserveTokenBalance - tokensToSend;
          ethReserves = ethReserves+ msg.value;
          return tokensToSend;


      }

       function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought){
          require(currentERC20.transferFrom(msg.sender, address(this), max_tokens), "Please add to your token balance or give this contract permission to handle your tokens");
           uint256 ethToSend = tokens_sold*continuousTokenPrice;
           msg.sender.send(ethToSend);
           reserveTokenBalance = reserveTokenBalance+ tokens_sold;
           ethReserves = ethReserves - ethToSend;
           return ethToSend;

       }


*/
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
