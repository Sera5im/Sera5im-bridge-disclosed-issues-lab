# Context

Decent is a cross-chain routing stack that combines:

- source-side bridge initiation,
- LayerZero-based message delivery,
- destination-side token handling,
- optional post-bridge execution.

For the `H-03` path, the important destination flow is:

1. bridged OFT value arrives into the destination router
2. router decodes the payload
3. router approves the bridge executor
4. executor attempts the destination call
5. if that call fails, executor refunds WETH

The bug is that the refund recipient is not the real user refund address. Under normal protocol usage, the encoded `_from` value is an internal bridge-side address, so failure refunds can strand funds away from the user.
