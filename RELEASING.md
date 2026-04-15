# Releasing WalletIOS

## Branch policy

- `main` is for the next minor line under active development.
- Each stabilizing minor line gets a long-lived branch named `release/vX.Y`.
- Patch releases for that line are cut from the matching `release/vX.Y` branch.
- Do not create one branch per patch version.

Example:
- Cut `release/v2.9` from `main` when `2.9.0` enters stabilization.
- Bump `main` forward to `2.10.0` so next-minor work continues there.
- Ship `v2.9.0`, `v2.9.1`, `v2.9.2` from the release commits on `release/v2.9`.

## Release notes policy

- Every version bump PR must add or update `.github/releases/vX.Y.Z.md`.
- Release notes must include:
  - `## Changes`
  - at least one `### [#PR](...) ...` entry
  - `## Backward incompatibilities`
- The release notes file should describe the shipped SDK changes in the same style used for GitHub Releases.

## Release PR policy

- Tags must point to the release commit that was actually shipped.
- Prod releases must only be run from:
  - `release/vX.Y` for patch releases where `Z > 0`
  - `main` or `release/vX.Y` for initial `vX.Y.0` releases

## Recommended flow

1. Cut `release/vX.Y` from `main`.
2. Bump `main` to the next minor version.
3. Prepare a release PR into `release/vX.Y` with the version bump and `.github/releases/vX.Y.Z.md`.
4. Merge that PR and use the resulting release commit as the source of truth for the shipped tag.
5. Run the prod release workflow from the release commit.
6. Cherry-pick or forward-port fixes between `release/vX.Y` and `main` as needed.
