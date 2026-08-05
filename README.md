# Bridge Disclosed Issues Lab

<img width="1983" height="793" alt="image" src="https://github.com/user-attachments/assets/034c21da-5993-4a45-809e-9c421aae582e" />


Local PoC lab for already disclosed bridge and cross-chain findings.

This repo is not a live bug bounty report set. It rebuilds public findings into short notes, local PoCs, and runnable tests.

## What this repo does

- takes public disclosed findings from bridge / cross-chain contests,
- rewrites them into short finding notes,
- keeps one short invariant per issue,
- adds local PoC tests where practical.

## Source reports

- LayerZero Ovault: [Cantina public report](https://cantina.xyz/portfolio/e4d93441-0fe3-4b64-bf98-fa31ecef4fb5)
- Ondo Bridge Registrar & USDon Converter: [Cantina public report](https://cantina.xyz/portfolio/91210482-130b-478a-848c-773029679a90)
- Decent Cross-Chain Router: [Code4rena public report](https://code4rena.com/reports/2024-01-decent)

## Packs

### 1. LayerZero Ovault

- path: `layerzero-ovault/`
- covered here: `1` high, `5` medium

### 2. Ondo Bridge Registrar & USDon Converter

- path: `ondo-bridge-registrar-usdon/`
- covered here: `1` medium, `2` low

### 3. Decent Cross-Chain Router

- path: `decent-cross-chain-router/`
- covered here: `2` high, `1` medium

## Repo pattern

```text
case-name/
|-- context.md
|-- findings/
|   |-- H-01.md
|   |-- M-01.md
|   `-- L-01.md
|-- poc/
|   `-- *.t.sol
`-- src/
    `-- *Mocks.sol
```

## Notes

- findings here are based on public reports
- PoCs here are local reconstructions
- this repo is for practice, case-study replay, and portfolio use
