# Context

## What this case is about

This is a bridge-adjacent OFT registration issue.

The `BridgeRegistrar` deploys and wires a new OFT instance for a token. That OFT is later expected to support normal cross-chain send semantics:

1. user calls `send(...)`
2. OFT enters `_debit(...)`
3. OFT burns the local token amount
4. LayerZero transport continues outbound

## Why the medium issue matters

If the registered OFT can mint but cannot burn, outbound bridging is not actually operational.

That means the registration path does not finish provisioning the token for real OFT send semantics.

## Main invariant

If a token is registered for OFT bridging, the OFT must receive every token-side role required by its mint and burn paths.
