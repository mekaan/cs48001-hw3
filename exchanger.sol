pragma solidity ^0.8.0;

import "./token.sol";

contract Exchanger {
    mapping (address => bool) private _whitelist;
    address governance_contract;
    
    constructor(address governance_contract_address){
        governance_contract=governance_contract_address;
    }
    
    function transfer(address from_addrs, address to_addrs, uint256 amount) public returns (bool success) {
        require(_whitelist[from_addrs]==true, "Token is not allowed!");
        require(_whitelist[to_addrs]==true, "Token is not allowed!");
        HW2Token token1 = HW2Token(from_addrs);
        HW2Token token2 = HW2Token(to_addrs);
        
        // Verify allowance
        // This must be manually set by the user for security
        // (at least I did not find any other way)
        require(token1.allowance(msg.sender,address(this)) >= amount, "User allowance error!");
        
        // Check balance of contract and user 
        // (user part is probably unnecessary since it is checked in the first transfer)
        require(token1.balanceOf(msg.sender) >= amount, "User balance error!");
        require(token2.balanceOf(address(this)) >= amount, "Contract balance error!");
        
        // Take token1 from the user (make sure it succeeds)
        // Should not fail since we checked the balance but just to make sure
        require(token1.transferFrom(msg.sender,address(this),amount), "Transfer (from) error!");
        
        // Give token2 to user from contract's address
        require(token2.transfer(msg.sender,amount),"Transfer (to) error!");
        
        return true;
    }
    
    function addtoken(address token) public returns (bool success){
        //Only usable by governance contract address
        require(msg.sender==governance_contract, "Only callable by governance contract!");
        
        //adding token to whitelist
        _whitelist[token]=true;
        
        return true;
    }
}

