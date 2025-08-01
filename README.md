# hello-world-trap
🚨 Smart-contract trap | helloworld() test | ⚖️ Balance change alerts
# 🎯 Objective
Create a functional and deployable Drosera trap that:

- Monitors ETH balance anomalies of **two operator wallets**,
- Uses the standard `collect()` / `shouldRespond()` interface,
- Triggers a response when **any balance deviation is detected**,
- Returns an alert if either balance has changed since the last check.


---

# Problem

Ethereum operator contracts used in automation, asset routing, DAO management, or protocol operations must remain stable over time.  
Any untracked movement — deposit or withdrawal — can suggest an exploit, system error, or unintended interference.

🧩 **Solution**: Track ETH balances of two known operators.  
Trigger alerts if either operator’s balance has changed._

---

# Trap Logic Summary

_Trap Contract: DRDSER4Trap.sol_

_Pay attention to this string "address public constant target = 0x2aCEeCC0d79C54569aF451d354498Bb80Efe6C41; // change 0x6a2CB0D4a32F4AB4b8c401307696dA73b430733c to your own wallet address"_
```
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

```

# Response Contract: DRDSER4Trap.sol
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogAlertReceiver {
    event Alert(string message);

    function logAnomaly(string calldata message) external {
        emit Alert(message);
    }
}
```
---

# What It Solves 

✅ Detects unauthorized ETH movements across multiple operator addresses
✅ Emits automated alert upon detection
✅ Can integrate with Drosera-compatible receivers to trigger defensive or governance mechanisms

---

# Deployment & Setup Instructions 

1. ## _Deploy Contracts (e.g., via Foundry)_ 
```
forge create src/DRDSER4Trap.sol:DRDSER4Trap \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key 0x...
```
```
forge create src/ResponseProtocol.sol:ResponseProtocol \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key 0x...
```
2. ## _Update drosera.toml_ 
```
[traps.helloworldtrap]
path = "out/DRDSER4Trap.sol/DRDSER4Trap.json"  # Путь к ABI
response_contract = "addrees"  # Адрес контракта ResponseProtocol
response_function = "helloworld(string)"  # Имя функции
```
3. ## _Apply changes_ 
```
DROSERA_PRIVATE_KEY=0x... drosera apply
```

<https://github.com/oki1976/hello-world-trap/commit/ab3ec32855cab43ee9379d2ebf2c74af7e9bfdec" />


# Testing the Trap 

1. Send ETH to/from either OPERATOR1 or OPERATOR2 on Ethereum Hoodi testnet

2. Wait 1–3 blocks

- Observe Drosera logs or dashboard:

 -Should show: ShouldRespond = true

 -Trigger alert will be emitted
---

# Extensions & Improvements 

- Add custom alert messages based on which operator changed

- Monitor ERC-20 token balances alongside ETH

- Add cooldown logic before re-alerting

- Use more advanced anomaly models (e.g., % deviation)


# Date & Author

_First created: July 29, 2025_

## Author: Oktay && Profit_Nodes 
TG : _@oktaj21_

Discord: _oktay4814_







