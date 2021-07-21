// SPDX-License-Identifier: GPL-3.0 (2)
pragma solidity ^0.5.12; // => must use exact version 0.5.12 (1)

// => Need to add the import statement to use SafeMath library (3)

contract Crowdsale {
   using SafeMath for uint256;

   address public owner; // the owner of the contract
   address public escrow; // wallet to collect raised ETH // => must be payable (8)
   uint256 public savedBalance = 0; // Total amount raised in ETH // => variable initialization is not needed (5)
   mapping (address => uint256) public balances; // Balances in incoming Ether

   // Initialization
   function Crowdsale(address _escrow) public { // => constructor keyword (4)
       owner = tx.origin; // => must use msg.sender instead of tx.origin (6)
       // add address of the specific contract
       escrow = _escrow;
   }

   // function to receive ETH
   function() public { // => function must be declared external and payable (7)
       balances[msg.sender] = balances[msg.sender].add(msg.value);
       savedBalance = savedBalance.add(msg.value);
       escrow.send(msg.value); // => use of .call{value : amount}(“”) instead (9)
   }

   // refund investisor
   function withdrawPayments() public{ // => (10) (11)
       address payee = msg.sender;
       uint256 payment = balances[payee];

       payee.send(payment); // => use of .call{value : amount}(“”) instead; reentrance issue here (9)

       savedBalance = savedBalance.sub(payment); // => those 2 lines must be executed before the send method
       balances[payee] = 0;
   }
}