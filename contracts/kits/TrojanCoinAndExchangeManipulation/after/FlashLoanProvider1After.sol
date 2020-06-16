pragma solidity ^0.6.6;

import "../../../../contracts/interfaces/basic/safemath.sol";
import "../../../../contracts/interfaces/basic/ERC20.sol";

contract FlashLoanProvider1After{




          string public constant name = "Example Dai and Liquidity Provider All in One";
          string public constant symbol = "EDAI";
          uint8 public constant decimals = 18;
          uint public _totalSupply = 1000000000000000000000000;
          address marketplaceAddress;
          bool firstTransfer= true;

          //variables use in attacks later
          bool updateSupplyActivated = false;
          bool reentryActivated = false;
          uint256 defaultReentryTradeAmount = 10000000000000000000;
          uint256 defaultTotalSupplyToAdd= 10000000000000000000000;


          using SafeMath for uint256;
          address public owner;

           modifier onlyOwner() {
              if (msg.sender != owner) {
                  revert();
              }
               _;
           }


          mapping(address => uint256) balances;

          mapping(address => mapping(address=>uint256)) allowed;



          // Constructor
          constructor() public payable {

              owner = msg.sender;
              balances[address(this)] = _totalSupply;
              transfer( msg.sender, _totalSupply);
          }

          function totalSupply() public view returns(uint256){
              return _totalSupply;
          }

          function balanceOf(address _owner) public view returns(uint256){
              return balances[_owner];
          }


          function transfer(address _to, uint256 _value)  public returns(bool) {


              balances[_to] = balances[_to].add(_value);
              emit Transfer(msg.sender, _to, _value);


              return true;
          }

      function borrow(uint256 amount) public returns(bool){
        _totalSupply = _totalSupply.add(amount);
        transfer(msg.sender, amount);
        return true;
      }

      function borrowToken(address toBorrowToken, uint256 amount) public returns(bool){

        ERC20 borrowToken1 = ERC20(toBorrowToken);
        borrowToken1.transfer(msg.sender, amount);
      }


      function mintTokensTo(address theAddress, uint256 amount) public returns(bool){
        _totalSupply = _totalSupply.add(amount);
        transfer(theAddress, amount);
        return true;
      }



      function transferFrom(address _from, address _to, uint256 _value)  public returns(bool) {
          require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0, "Not having enough permission or balance too low");
          balances[_from] = balances[_from].sub(_value);
          balances[_to] = balances[_to].add(_value);
          allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
          emit  Transfer(_from, _to, _value);
          return true;
      }


      function approve(address _spender, uint256 _value) public returns(bool){
          allowed[msg.sender][_spender] = _value;
          Approval(msg.sender, _spender, _value);
          return true;
      }


      function allowance(address _owner, address _spender) public view returns(uint256){
          return allowed[_owner][_spender];
      }

      event Transfer(address indexed _from, address indexed _to, uint256 _value);
      event Approval(address indexed _owner, address indexed _spender, uint256 _value);




}
