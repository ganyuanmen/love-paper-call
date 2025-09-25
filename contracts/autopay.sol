// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AutoPay {
    IERC20 public immutable UTO;
    uint256 public constant REWARD = 2000 * 1e18; // 18 decimals
    uint256 public constant MAX_TOTAL = 2100000 * 1e18;
    uint256 public paid;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(address _uto) {
        UTO = IERC20(_uto);
        owner = msg.sender;
    }

    // GitHub Action 调用此函数
    function batchPay(address[] calldata wallets) external onlyOwner {
        uint256 len = wallets.length;
        uint256 total = len * REWARD;
        require(paid + total <= MAX_TOTAL, "exceed");
        paid += total;
        for (uint256 i = 0; i < len; i++) {
            UTO.transfer(wallets[i], REWARD);
        }
    }

    // 多语言 bonus
    function bonusPay(address[] calldata wallets, uint256 times)
        external
        onlyOwner
    {
        uint256 total = wallets.length * times * 1000 * 1e18;
        require(paid + total <= MAX_TOTAL, "exceed");
        paid += total;
        for (uint256 i = 0; i < wallets.length; i++) {
            UTO.transfer(wallets[i], times * 1000 * 1e18);
        }
    }
}
