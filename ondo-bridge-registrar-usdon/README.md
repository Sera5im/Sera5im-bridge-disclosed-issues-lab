# Ondo Bridge Registrar & USDon Converter

Disclosed case-study pack for the public Ondo Bridge Registrar & USDon Converter report.

## Source

- [Cantina public report](https://cantina.xyz/portfolio/91210482-130b-478a-848c-773029679a90)

## Covered findings

- `M-01`
- `L-01`
- `L-02`

## Contents

- `context.md` - short protocol notes
- `findings/` - short rewritten notes
- `poc/M-01.t.sol` - main local PoC
- `src/M01Mocks.sol` - local mocks

## Format

Each finding file keeps only:

- `Source`
- `Issue`
- `Invariant`
- `PoC`

## Run

```bash
forge test --match-test test_SendRevertsWithoutBurnerRole -vv
```
