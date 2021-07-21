# Example of smart contract audit

1. Lock pragma to a specific version
2. Use "SPDX-License-Identifier : UNLICENSED" for non open-source code
3. Import SafeMath library
4. Use constructor keyword for the constructor instead of function
5. "savedBalance" variable initialization is not needed.
6. Use msg.sender instead of tx.origin
7. The fallback function must be external and payable to be able to receive ether
8. The escrow address must be payable to be able to receive ether
9. It is recommended to use the function "transfer" instead of "send" because "transfer" revert if there is an exception whereas "send" return false and the execution continues. 
This is the good way to do when using send:
    ```
    bool success;
    (success) = escrow.send(msg.value);
    require(success);
    ```
    But simply using "transfer" will revert the transaction if an error occur.
10. In the "withdrawPayments" function the payee address must be declared payable.
There is a reentrance issue at instruction payee.send(payment), one way to fix the issue is to set the balance of the investor to 0 before submitting the payment
    ```
    savedBalance = savedBalance.sub(payment);
    balances[payee] = 0;
    payee.transfer(payment);
    ```
    The require statements could be added in order to improve the code and save gaz in case the transaction is going to fail
    ```
    require(payment != 0);
    require(address(this).balance >= payment);
    ```
11. Use PullPayment pattern for the refund.