# Decent Cross-Chain Router

Disclosed case-study pack based on the public Code4rena report for Decent.

This pack now covers the strongest practical cases from the public report:

- `H-03` failed execution refunds bridged WETH to the wrong address
- `H-04` reserve shortfall strands the bridged claim inside the destination adapter
- `M-03` public receive path bypasses fees and signed instruction checks

Public report summary:

- `4` high findings
- `5` medium findings
- `3` low findings
- `2` non-critical findings

Contents:

- `context.md` - short protocol and flow context
- `findings/H-03.md` - wrong refund recipient on failed destination execution
- `findings/H-04.md` - reserve shortfall fallback strands value inside target-side adapter
- `findings/M-03.md` - public receive path bypasses fees and signed instructions
- `poc/H-03.t.sol` - local Foundry PoC for the first high issue
- `poc/H-04.t.sol` - local Foundry PoC for destination reserve shortfall
- `poc/M-03.t.sol` - local Foundry PoC for fee/signature bypass
- `src/H03Mocks.sol` - minimal mock contracts used by the H-03 PoC
- `src/H04Mocks.sol` - minimal mock contracts used by the H-04 PoC
- `src/M03Mocks.sol` - minimal mock contracts used by the M-03 PoC
- `references/links.md` - public source links

Run locally:

```bash
forge test -vv
```
