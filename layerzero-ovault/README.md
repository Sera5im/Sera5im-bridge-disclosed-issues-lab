# LayerZero Ovault

Disclosed case-study pack based on the public Cantina report for LayerZero Ovault.

This pack focuses on the six core findings:

- `H-01` Permanent loss of user funds due to logical error in refunds
- `M-01` Inflation attack is more profitable due to overridden functions in the vault contracts
- `M-02` Funds can be locked temporarily (or) permanently if slippage parameters cannot be satisfied
- `M-03` Transfers where `dstEid == HUB_EID` will fail
- `M-04` `msg.value` can be lost
- `M-05` Different slippage checks can lead to stuck funds

Contents:

- `findings/H-01.md`
- `findings/M-01.md`
- `findings/M-02.md`
- `findings/M-03.md`
- `findings/M-04.md`
- `findings/M-05.md`
- `poc/H-01.t.sol`
- `poc/M-01.t.sol`
- `poc/M-02.t.sol`
- `poc/M-03.t.sol`
- `poc/M-04.t.sol`
- `poc/M-05.t.sol`
- `src/OvaultMocks.sol`
- `references/links.md`

Run:

```bash
~/.foundry/bin/forge test -vv
```
