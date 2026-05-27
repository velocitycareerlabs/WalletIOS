# Backwards Compatibility Baselines

This directory contains tests that lock in current Swift SDK error propagation behavior for compatibility checks.

`ErrorTaxonomyBackwardCompatibilityBaselineTest` is modeled on `velocitycareerlabs/WalletAndroid#195`, but it intentionally asserts Swift SDK behavior where Swift currently differs from Android.

## Differences from Android

- Undecodable query parameters are accepted by `VCLDeepLink` and fail later at the SDK entrypoint with an SDK error. Android rejects these during deep link construction.
- Plain-text HTTP error responses preserve `message` and `statusCode`, but `payload` remains `nil`. Android preserves the same plain text in `payload` as well.
- Malformed or disallowed `request_uri` values surface as `NSURLErrorDomain Code=-1002` in Swift. Android exposes the corresponding Java URL error text.
- Non-JSON DID document responses fail while parsing, for example `Failed to parse not json`. The Android-modeled behavior continues to request validation and reports missing public JWK material.
- Missing DID verification material stores `public jwk not found for kid...` in `VCLError.error`, not `VCLError.message`.
