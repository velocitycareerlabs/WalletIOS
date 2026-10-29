#!/usr/bin/env node
//
//  generate_jwt_verification_fixtures.mjs
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0
//
// Generates VCLTests/infrastructure/resources/valid/JwtVerificationMocks.swift:
// a DID document with P-256 and secp256k1 JsonWebKey2020 verification methods,
// and ES256 / ES256K presentation requests and credential manifests signed by them.
//
// The output is reproducible. Private keys are derived from fixed seeds, and the
// ECDSA nonces follow RFC 6979, so running the script again rewrites the same file.
// Every signature is checked with OpenSSL (node:crypto) before the file is written.
//
// Usage: node VCL/scripts/generate_jwt_verification_fixtures.mjs

import { createECDH, createHash, createHmac, createPublicKey, verify } from 'node:crypto';
import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const CURVES = {
  'P-256': {
    alg: 'ES256',
    opensslName: 'prime256v1',
    n: 0xffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551n,
  },
  secp256k1: {
    alg: 'ES256K',
    opensslName: 'secp256k1',
    n: 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141n,
  },
};

const DID = 'did:web:devregistrar.velocitynetwork.foundation:d:es256-fixture.example.com';
const ISSUED_AT = 1760000000;
const OUTPUT_PATH = join(
  dirname(fileURLToPath(import.meta.url)),
  '..',
  'VCLTests',
  'infrastructure',
  'resources',
  'valid',
  'JwtVerificationMocks.swift',
);

const main = () => {
  selfTestRfc6979();

  const p256Key = deriveKey('P-256', 'walletios-jwt-verification-fixture-p256-exchange-key');
  const otherP256Key = deriveKey('P-256', 'walletios-jwt-verification-fixture-p256-other-key');
  const secp256k1Key = deriveKey('secp256k1', 'walletios-jwt-verification-fixture-secp256k1-exchange-key');

  const kids = {
    otherP256: `${DID}#other-key-p256`,
    p256: `${DID}#exchange-key-p256`,
    secp256k1: `${DID}#exchange-key-secp256k1`,
  };
  const didDocument = {
    id: DID,
    '@context': ['https://www.w3.org/ns/did/v1', 'https://w3id.org/security/suites/jws-2020/v1'],
    verificationMethod: [
      verificationMethod('#exchange-key-p256', p256Key),
      verificationMethod('#other-key-p256', otherP256Key),
      verificationMethod('#exchange-key-secp256k1', secp256k1Key),
    ],
    assertionMethod: ['#exchange-key-p256', '#other-key-p256', '#exchange-key-secp256k1'],
  };

  const presentationRequestDeepLink = deepLink('inspect', 'get-presentation-request', {
    id: '68f4a1f2c0ffee0001e5256a',
    inspectorDid: DID,
  });
  const credentialManifestDeepLink = deepLink('issue', 'get-credential-manifest', {
    id: '68f4a1f2c0ffee0001e5256b',
    credential_types: 'PastEmploymentPosition',
    issuerDid: DID,
  });

  const fixtures = {
    CredentialManifestDeepLinkStr: credentialManifestDeepLink,
    Did: DID,
    DidDocumentStr: JSON.stringify(didDocument),
    Es256CredentialManifestJwt: signJwt(p256Key, 'ES256', kids.p256, credentialManifestPayload('ES256')),
    Es256PresentationRequestJwt: signJwt(p256Key, 'ES256', kids.p256, presentationRequestPayload('ES256')),
    Es256PresentationRequestJwtWithHighS: withHighS(
      p256Key,
      signJwt(p256Key, 'ES256', kids.p256, presentationRequestPayload('ES256')),
    ),
    Es256PresentationRequestJwtWithSecp256k1Kid: signJwt(
      p256Key,
      'ES256',
      kids.secp256k1,
      presentationRequestPayload('ES256 with secp256k1 kid'),
    ),
    Es256kCredentialManifestJwt: signJwt(
      secp256k1Key,
      'ES256K',
      kids.secp256k1,
      credentialManifestPayload('ES256K'),
    ),
    Es256kCredentialManifestJwtWithP256Kid: signJwt(
      secp256k1Key,
      'ES256K',
      kids.p256,
      credentialManifestPayload('ES256K with P-256 kid'),
    ),
    Es256kPresentationRequestJwt: signJwt(
      secp256k1Key,
      'ES256K',
      kids.secp256k1,
      presentationRequestPayload('ES256K'),
    ),
    OtherP256Kid: kids.otherP256,
    P256Kid: kids.p256,
    PresentationRequestDeepLinkStr: presentationRequestDeepLink,
    Secp256k1Kid: kids.secp256k1,
  };

  writeFileSync(OUTPUT_PATH, swiftFile(fixtures));
  console.log(`Wrote ${OUTPUT_PATH}`);
};

const credentialManifestPayload = (label) => ({
  exchange_id: '68f4a1f2c0ffee0001e5256b',
  metadata: {
    client_name: `${label} Fixture Issuer`,
    logo_uri: 'https://docs.velocitycareerlabs.io/Logos/Logo.png',
    tos_uri: 'https://www.velocityexperiencecenter.com/terms-and-conditions-vnf',
    max_retention_period: '6m',
    progress_uri: 'https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/fixture/get-exchange-progress',
    submit_presentation_uri: 'https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/fixture/issue/submit-identification',
    check_offers_uri: 'https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/fixture/issue/credential-offers',
    finalize_offers_uri: 'https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/fixture/issue/finalize-offers',
  },
  presentation_definition: {
    id: '68f4a1f2c0ffee0001e5256b.6384a3ad148b1991687f67c9',
    purpose: 'Credentials offer',
    format: { jwt_vp: { alg: ['secp256k1'] } },
    input_descriptors: [
      { id: 'EmailV1.0', schema: [{ uri: 'https://devregistrar.velocitynetwork.foundation/schemas/email-v1.0.schema.json' }] },
    ],
    submission_requirements: [{ rule: 'all', from: 'A', min: 1 }],
  },
  output_descriptors: [{ id: 'PastEmploymentPosition', name: 'Past employment position' }],
  issuer: { id: DID },
  iss: DID,
  iat: ISSUED_AT,
  nbf: ISSUED_AT,
});

const presentationRequestPayload = (label) => ({
  exchange_id: '68f4a1f2c0ffee0001e5256a',
  metadata: {
    client_name: `${label} Fixture Inspector`,
    logo_uri: 'https://docs.velocitycareerlabs.io/Logos/Logo.png',
    tos_uri: 'https://www.velocityexperiencecenter.com/terms-and-conditions-vnf',
    max_retention_period: '6m',
    progress_uri: 'https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/fixture/get-exchange-progress',
    submit_presentation_uri: 'https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/fixture/inspect/submit-presentation',
  },
  presentation_definition: {
    id: '68f4a1f2c0ffee0001e5256a.6384a3ad148b1991687f67c9',
    purpose: 'Fixture presentation',
    name: 'Share your email',
    format: { jwt_vp: { alg: ['secp256k1'] } },
    input_descriptors: [
      { id: 'EmailV1.0', schema: [{ uri: 'https://devregistrar.velocitynetwork.foundation/schemas/email-v1.0.schema.json' }] },
    ],
    submission_requirements: [{ rule: 'all', from: 'A', min: 1 }],
  },
  iss: DID,
  iat: ISSUED_AT,
  nbf: ISSUED_AT,
});

const deepLink = (flow, path, params) => {
  const query = Object.entries(params).map(([key, value]) => `${key}=${value}`).join('&');
  const requestUri = `https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/${DID}/${flow}/${path}?${query}`;
  return `velocity-network-devnet://${flow}?request_uri=${encodeURIComponent(requestUri)}`;
};

const verificationMethod = (id, key) => ({
  id,
  type: 'JsonWebKey2020',
  controller: DID,
  publicKeyJwk: key.publicJwk,
});

const deriveKey = (curveName, seed) => {
  const curve = CURVES[curveName];
  const d = (bytesToInt(sha256(Buffer.from(seed))) % (curve.n - 1n)) + 1n;
  const point = multiplyGenerator(curve, d);
  return {
    curve,
    d,
    publicJwk: {
      kty: 'EC',
      crv: curveName,
      x: base64url(point.subarray(1, 33)),
      y: base64url(point.subarray(33, 65)),
    },
  };
};

const signJwt = (key, alg, kid, payload) => {
  if (alg !== key.curve.alg) {
    throw new Error(`${alg} cannot be signed with a ${key.publicJwk.crv} key`);
  }
  const header = { typ: 'JWT', alg, kid };
  const signingInput = `${base64url(Buffer.from(JSON.stringify(header)))}.${base64url(Buffer.from(JSON.stringify(payload)))}`;
  const signature = ecdsaSign(key.curve, key.d, Buffer.from(signingInput));
  const publicKey = createPublicKey({ key: key.publicJwk, format: 'jwk' });
  if (!verify('sha256', Buffer.from(signingInput), { key: publicKey, dsaEncoding: 'ieee-p1363' }, signature)) {
    throw new Error(`OpenSSL rejected the ${alg} fixture signed for ${kid}`);
  }
  return `${signingInput}.${base64url(signature)}`;
};

// Same signature with s replaced by n - s. Both forms are valid ECDSA signatures, and JOSE
// signers such as KMS or jose do not normalize s, so verifiers must accept high s for ES256.
const withHighS = (key, jwt) => {
  const [header, payload, encodedSignature] = jwt.split('.');
  const signature = Buffer.from(encodedSignature, 'base64url');
  const s = bytesToInt(signature.subarray(32));
  const highS = s > key.curve.n / 2n ? s : key.curve.n - s;
  const highSSignature = Buffer.concat([signature.subarray(0, 32), intToBytes(highS)]);
  const publicKey = createPublicKey({ key: key.publicJwk, format: 'jwk' });
  if (!verify('sha256', Buffer.from(`${header}.${payload}`), { key: publicKey, dsaEncoding: 'ieee-p1363' }, highSSignature)) {
    throw new Error('OpenSSL rejected the high-s fixture');
  }
  return `${header}.${payload}.${base64url(highSSignature)}`;
};

// ECDSA over SHA-256 with RFC 6979 nonces. Returns the JWS (IEEE P1363) form r || s with low s.
const ecdsaSign = (curve, d, message) => {
  const { r, s } = ecdsaSignHash(curve, d, sha256(message));
  const lowS = s > curve.n / 2n ? curve.n - s : s;
  return Buffer.concat([intToBytes(r), intToBytes(lowS)]);
};

const ecdsaSignHash = (curve, d, hash) => {
  const k = rfc6979Nonce(curve, d, hash);
  const r = bytesToInt(multiplyGenerator(curve, k).subarray(1, 33)) % curve.n;
  const s = (modPow(k, curve.n - 2n, curve.n) * (bytesToInt(hash) + r * d)) % curve.n;
  if (r === 0n || s === 0n) {
    throw new Error('Degenerate ECDSA signature');
  }
  return { k, r, s };
};

// RFC 6979 section 3.2 with HMAC-SHA256; qlen = hlen = 256 for both curves.
const rfc6979Nonce = (curve, d, hash) => {
  const hmac = (key, ...parts) => createHmac('sha256', key).update(Buffer.concat(parts)).digest();
  const privateKey = intToBytes(d);
  const reducedHash = intToBytes(bytesToInt(hash) % curve.n);
  let v = Buffer.alloc(32, 0x01);
  let k = Buffer.alloc(32, 0x00);
  k = hmac(k, v, Buffer.from([0x00]), privateKey, reducedHash);
  v = hmac(k, v);
  k = hmac(k, v, Buffer.from([0x01]), privateKey, reducedHash);
  v = hmac(k, v);
  for (;;) {
    v = hmac(k, v);
    const candidate = bytesToInt(v);
    if (candidate >= 1n && candidate < curve.n) {
      return candidate;
    }
    k = hmac(k, v, Buffer.from([0x00]));
    v = hmac(k, v);
  }
};

// Known-answer tests: RFC 6979 A.2.5 (P-256, SHA-256, "sample") and the widely used
// secp256k1 vector (d = 1, SHA-256, "Satoshi Nakamoto").
const selfTestRfc6979 = () => {
  const p256 = ecdsaSignHash(
    CURVES['P-256'],
    0xc9afa9d845ba75166b5c215767b1d6934e50c3db36e89b127b8a622b120f6721n,
    sha256(Buffer.from('sample')),
  );
  assertEqual(p256.k, 0xa6e3c57dd01abe90086538398355dd4c3b17aa873382b0f24d6129493d8aad60n, 'P-256 k');
  assertEqual(p256.r, 0xefd48b2aacb6a8fd1140dd9cd45e81d69d2c877b56aaf991c34d0ea84eaf3716n, 'P-256 r');
  assertEqual(p256.s, 0xf7cb1c942d657c41d436c7a1b6e29f65f3e900dbb9aff4064dc4ab2f843acda8n, 'P-256 s');

  const secp256k1 = ecdsaSignHash(CURVES.secp256k1, 1n, sha256(Buffer.from('Satoshi Nakamoto')));
  assertEqual(secp256k1.k, 0x8f8a276c19f4149656b280621e358cce24f5f52542772691ee69063b74f15d15n, 'secp256k1 k');
};

const assertEqual = (actual, expected, label) => {
  if (actual !== expected) {
    throw new Error(`RFC 6979 self-test failed for ${label}: ${actual.toString(16)} != ${expected.toString(16)}`);
  }
};

// k * G through OpenSSL: the ECDH public key for private key k is the uncompressed point k * G.
const multiplyGenerator = (curve, k) => {
  const ecdh = createECDH(curve.opensslName);
  ecdh.setPrivateKey(intToBytes(k));
  return ecdh.getPublicKey();
};

const modPow = (base, exponent, modulus) => {
  let result = 1n;
  let b = base % modulus;
  let e = exponent;
  while (e > 0n) {
    if (e & 1n) {
      result = (result * b) % modulus;
    }
    b = (b * b) % modulus;
    e >>= 1n;
  }
  return result;
};

const sha256 = (data) => createHash('sha256').update(data).digest();
const base64url = (data) => Buffer.from(data).toString('base64url');
const bytesToInt = (bytes) => BigInt(`0x${Buffer.from(bytes).toString('hex')}`);
const intToBytes = (value) => Buffer.from(value.toString(16).padStart(64, '0'), 'hex');

const swiftString = (value) => {
  if (!/^[\x20-\x7e]*$/.test(value)) {
    throw new Error(`Fixture is not printable ASCII: ${value}`);
  }
  return `"${value.replace(/\\/g, '\\\\').replace(/"/g, '\\"')}"`;
};

const swiftFile = (fixtures) => {
  const constants = Object.keys(fixtures)
    .sort()
    .map((name) => `    static let ${name} =\n        ${swiftString(fixtures[name])}`)
    .join('\n\n');
  return `//
//  JwtVerificationMocks.swift
//  VCLTests
//
//  Generated by VCL/scripts/generate_jwt_verification_fixtures.mjs. Do not edit by hand.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class JwtVerificationMocks {
${constants}

    static let DidDocument = VCLDidDocument(payloadStr: DidDocumentStr)
}
`;
};

main();
