# Ondo Bridge Registrar & USDon Converter

Disclosed case-study pack based on the public Cantina report for Ondo Bridge Registrar & USDon Converter.

This folder keeps three things:

- short rewritten findings
- a local PoC for the main medium issue
- source links back to the public report and fix

Contents:

- `context.md` - short protocol and flow context
- `findings/M-01.md` - missing `BURNER_ROLE` breaks OFT outbound sends
- `findings/L-01.md` - precision loss in `USDon -> USDC` redemption
- `findings/L-02.md` - hardcoded conversion rate breaks chains with 18-decimal USDC
- `poc/M-01.t.sol` - mock-based Foundry PoC for the medium issue
- `src/M01Mocks.sol` - minimal mock contracts used by the PoC
- `references/links.md` - public source links

Run locally:

```bash
forge test --match-test test_SendRevertsWithoutBurnerRole -vv
```
