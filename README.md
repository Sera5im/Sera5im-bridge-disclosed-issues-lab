# Bridge Disclosed Issues Lab

Case-study lab for public bridge and cross-chain findings.

This repository is not a live bug bounty report set. It is a local training and portfolio lab built around already disclosed public findings, rewritten into:

- short finding writeups,
- minimal mock-based PoCs,
- runnable local tests,
- source links back to the original public report.

## Current packs

### 1. LayerZero Ovault

Path:

- `layerzero-ovault/`

Focus:

- one high finding,
- five medium findings,
- local Foundry PoC coverage for the core cases.

Main files:

- `layerzero-ovault/README.md`
- `layerzero-ovault/findings/`
- `layerzero-ovault/poc/H-01.t.sol`
- `layerzero-ovault/poc/M-01.t.sol`
- `layerzero-ovault/poc/M-02.t.sol`
- `layerzero-ovault/poc/M-03.t.sol`
- `layerzero-ovault/poc/M-04.t.sol`
- `layerzero-ovault/poc/M-05.t.sol`
- `layerzero-ovault/src/OvaultMocks.sol`
- `layerzero-ovault/references/links.md`

### 2. Ondo Bridge Registrar & USDon Converter

Path:

- `ondo-bridge-registrar-usdon/`

Focus:

- one medium finding,
- two low findings,
- local Foundry PoC for the main medium issue.

Main files:

- `ondo-bridge-registrar-usdon/README.md`
- `ondo-bridge-registrar-usdon/context.md`
- `ondo-bridge-registrar-usdon/findings/`
- `ondo-bridge-registrar-usdon/poc/M-01.t.sol`
- `ondo-bridge-registrar-usdon/src/M01Mocks.sol`
- `ondo-bridge-registrar-usdon/references/links.md`

### 3. Decent Cross-Chain Router

Path:

- `decent-cross-chain-router/`

Focus:

- public report total: `4` high, `5` medium, `3` low, `2` non-critical
- local pack starts from `H-03`
- first PoC models wrong-recipient refund on failed destination execution

Main files:

- `decent-cross-chain-router/README.md`
- `decent-cross-chain-router/context.md`
- `decent-cross-chain-router/findings/H-03.md`
- `decent-cross-chain-router/poc/H-03.t.sol`
- `decent-cross-chain-router/src/H03Mocks.sol`
- `decent-cross-chain-router/references/links.md`

## Folder pattern

Each case-study pack should follow the same layout:

```text
case-name/
├── README.md
├── context.md                # optional protocol / flow notes
├── findings/
│   ├── H-01.md
│   ├── M-01.md
│   └── L-01.md
├── poc/
│   └── *.t.sol
├── src/
│   └── *Mocks.sol
└── references/
    └── links.md
```

## What this lab is for

- turning disclosed bridge findings into repeatable local exploit exercises,
- learning cross-chain failure modes by writing PoCs instead of only reading reports,
- building a public portfolio around bridge and cross-chain security research.

## Next expansion targets

- add one more recent bridge contest case with at least one medium-severity PoC,
- normalize every pack to the same `README / findings / poc / references` structure,
- keep one finding per file and one PoC per issue where practical,
- add short fix notes to each finding file once the public patch is known.
