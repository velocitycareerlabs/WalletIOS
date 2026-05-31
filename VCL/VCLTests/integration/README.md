# Backwards Compatibility Baselines

This directory contains tests that lock in current Swift SDK error propagation behavior for compatibility checks.

`ErrorTaxonomyBackwardCompatibilityBaselineTest` is modeled on `velocitycareerlabs/WalletAndroid#195`, but it intentionally asserts Swift SDK behavior where Swift currently differs from Android.

## Differences from Android

- Undecodable query parameters are accepted by `VCLDeepLink` and fail later at the SDK entrypoint with an SDK error. Android rejects these during deep link construction.
- Malformed or disallowed `request_uri` values surface as `NSURLErrorDomain Code=-1002` in Swift. Android exposes the corresponding Java URL error text.
