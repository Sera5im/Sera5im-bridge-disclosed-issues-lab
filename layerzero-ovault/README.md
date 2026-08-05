# LayerZero Ovault

Disclosed case-study pack for the public LayerZero Ovault report.

## Source

- [Cantina public report](https://cantina.xyz/portfolio/e4d93441-0fe3-4b64-bf98-fa31ecef4fb5)

## Covered findings

- `H-01`
- `M-01`
- `M-02`
- `M-03`
- `M-04`
- `M-05`

## Contents

- `findings/` - short rewritten notes
- `poc/` - one PoC test per issue
- `src/OvaultMocks.sol` - local mocks

## Format

Each finding file keeps only:

- `Source`
- `Issue`
- `Invariant`
- `PoC`

## Run

```bash
~/.foundry/bin/forge test -vv
```
