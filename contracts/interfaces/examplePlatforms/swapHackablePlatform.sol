pragma solidity ^0.6.6;

interface platformToHack{
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToTokenSwap(address fromToken, address toToken, uint256 amountFrom) external returns(uint256);
    function getTokenPrice(uint256 amount1) view external returns(uint256);
}
