// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableVault {
    address public owner;
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    // VULNERABILITY: Missing access control modifier! Anyone can call this.
    function changeOwner(address _newOwner) external {
        owner = _newOwner;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function emergencyDrain() external {
        require(msg.sender == owner, "Not the owner!");
        payable(owner).transfer(address(this).balance);
    }
}