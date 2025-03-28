// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract AIT {
    mapping(address=> uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    mapping(address => bool) public isTransferDisable;
    uint public totalSupply = 10000000000 * 10 ** 18;
    uint public decimals = 18;
    string public name = "Artifical Intelligence Tech";
    string public symbol = "AIT";
    address private admin;

    modifier onlyAdmin() {
        require(admin == msg.sender, "Insufficient Access");
        _;
    }

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event EnableTransfer(address indexed owner, uint timestamp);
    event DisableTransfer(address indexed owner, uint timestamp);
    event Burn(address indexed burner, uint value);

    constructor() {
        admin = msg.sender;
        balances[msg.sender] = totalSupply;
    }
 
    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    }

    function transfer(address to, uint value) public returns(bool) {
        require(!isTransferDisable[msg.sender], "Transfer is Disabled for the user");
        require(balanceOf(msg.sender) >= value, "balance too low");
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns(bool) {
        require(!isTransferDisable[from], "Transfer is Disabled for the user");
        require(balanceOf(from) >= value, "balance too low");
        require(allowance[from][msg.sender] >= value, "allowance too low");
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint value) public returns(bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function enableTransfer(address _address) external onlyAdmin() {
        require(isTransferDisable[_address], "Transfer is already enabled for the user");
        isTransferDisable[_address] = false;
        emit EnableTransfer(_address, block.timestamp);
    }

    function disableTransfer(address _address) external onlyAdmin() {
        require(!isTransferDisable[_address], "Transfer is already disable for the user");
        isTransferDisable[_address] = true;
        emit DisableTransfer(_address, block.timestamp);
    }

    function getAdmin() external view returns(address) {
        return admin;
    }

    function setAdmin(address _owner) external onlyAdmin() {
        admin = _owner;
    }

    function burn(uint value) external returns (bool) {
        require(balanceOf(msg.sender) >= value, "Balance too low for burn");
        balances[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
        return true;
    }
}