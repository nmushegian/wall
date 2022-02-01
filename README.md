`Wall` is a mixin for DELEGATECALL-safe multi-user auth.

It gives your contract a function `gate`, which is like `ward` (from [Ward](https://github.com/nmushegian/ward))
except that the whitelist lives in a different contract, whose address is recorded in code (`immutable` keyword),
making it safe against misbehaving DELEGATECALLS.

The whitelist contract is a global singleton that uses the 'multicontract' / 'protocol contract' pattern, which is
where the application logic is partitioned by `msg.sender` and each contract is given a distinct view.