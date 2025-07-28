// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes calldata data) external pure returns (bool, bytes memory);
}

contract DRDSER4Trap is ITrap {
    uint256 public constant BLOCK_SAMPLE_SIZE = 10;
    uint256 public constant COOLDOWN_BLOCKS = 33;

    address public constant OPERATOR1 = 0x6a2EC0bDA342F4B4b8c401307696Ad73b430733c;
    address public constant OPERATOR2 = 0x2aCEcCC0d79C54569aF451d354498bB80Ef6C41;

    function collect() external view override returns (bytes memory) {
        return abi.encode(OPERATOR1.balance, OPERATOR2.balance, block.number);
    }

    function shouldRespond(bytes calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, "");

        (uint256 op1Current, uint256 op2Current, ) = abi.decode(data[0], (uint256, uint256, uint256));
        (uint256 op1Prev, uint256 op2Prev, ) = abi.decode(data[1], (uint256, uint256, uint256));

        bool changed = (op1Current != op1Prev || op2Current != op2Prev);
        return (changed, abi.encode("ALERT"));
    }
}
