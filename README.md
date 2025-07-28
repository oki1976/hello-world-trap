# hello-world-trap
🚨 Smart-contract trap | helloworld() test | ⚖️ Balance change alerts
## 🎯 Objective
# DRDSER4Trap  
Balance Anomaly Trap — Drosera Trap SERGEANT

---

## Objective

Create a functional and deployable Drosera trap that:

- Monitors ETH balance anomalies of **two operator wallets**,
- Uses the standard `collect()` / `shouldRespond()` interface,
- Triggers a response when **any balance deviation is detected**,
- Returns an alert if either balance has changed since the last check.

---

## Problem

Ethereum operator contracts used in automation, asset routing, DAO management, or protocol operations must remain stable over time.  
Any untracked movement — deposit or withdrawal — can suggest an exploit, system error, or unintended interference.

🧩 **Solution**: Track ETH balances of two known operators.  
Trigger alerts if either operator’s balance has changed.

---

## Trap Logic Summary

**Trap Contract**: `DRDSER4Trap.sol`

📌 Pay attention to this line:

```solidity
address public constant OPERATOR1 = 0x6a2EC0bDA342F4B4b8c401307696Ad73b430733c;
address public constant OPERATOR2 = 0x2aCEcCC0d79C54569aF451d354498bB80Ef6C41;
Replace with your own monitored operator addresses if needed.








