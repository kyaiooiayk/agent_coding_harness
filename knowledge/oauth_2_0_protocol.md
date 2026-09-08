---
type: Reference
title: OAuth 2.0 protocol security cheatsheet
description: Current security practices for OAuth 2.0 and OpenID Connect, including PKCE, sender-constrained tokens, token restriction, and deprecated grants.
tags: [oauth, oidc, authentication, authorization, security]
timestamp: 2026-07-18T00:00:00Z
---

# OAuth 2.0 protocol security cheatsheet

This reference summarizes current security practices for OAuth 2.0, primarily from
[OAuth 2.0 Security Best Current Practice (RFC 9700)](https://www.rfc-editor.org/rfc/rfc9700).
OAuth is the standard framework for delegated API authorization and is the basis for federated
login through [OpenID Connect 1.0](https://openid.net/specs/openid-connect-core-1_0.html). OpenID
Connect adds an identity layer that lets clients verify an end user's identity and obtain basic
profile information.

OAuth 2.0 supports several token protection models. Bearer tokens provide simplicity and broad
interoperability. Sender-constrained tokens use proof of possession to bind a token to key
material controlled by its client. Select a model according to the application's threat model,
client capabilities, and operational constraints.

## Terminology

- **Client:** An application making protected-resource requests on behalf of a resource owner and
  with that owner's authorization. The term does not imply whether the application runs on a
  server, desktop, browser, or another device.
- **Authorization Server (AS):** The server that issues access tokens after authenticating the
  resource owner when required and obtaining authorization.
- **Resource Owner (RO):** An entity capable of granting access to a protected resource. A person
  in this role is an end user; the role may also be held by an organization or system.
- **Resource Server (RS):** The server that hosts protected resources and accepts access tokens.
- **Access token:** A credential representing delegated authorization. It lets a Resource Server
  validate a common token rather than understand every upstream authentication method. Access
  tokens should be short-lived and restricted by audience, scope, resource, and action.
- **Refresh token:** A credential issued by an Authorization Server for obtaining new access
  tokens with identical or narrower authorization. Refresh tokens require strong storage and
  replay protection through sender-constraining, rotation, or both.
- **Bearer token:** A token usable by any party that possesses it, as defined by
  [RFC 6750](https://www.rfc-editor.org/rfc/rfc6750). Because possession is sufficient, leakage
  has immediate consequences. Bearer access tokens should be restricted to a single audience
  whenever possible.
- **Proof-of-Possession (PoP) token:** An access or refresh token cryptographically bound to key
  material controlled by the client. The client must prove possession of the corresponding
  private key when using the token. Common sender-constraining mechanisms are DPoP and mTLS.

## OAuth 2.0 essential basics

- Clients and Authorization Servers must not expose open redirectors that forward a browser to an
  arbitrary URI obtained from a request parameter. Open redirectors can enable authorization-code
  or token exfiltration.
- Authorization responses must use TLS. Authorization Servers must reject `http` redirect URIs
  except where a specification explicitly permits them, such as loopback redirects for native
  applications.
- Redirect URIs should be matched exactly against pre-registered values. Avoid pattern and
  wildcard matching.
- Authorization Servers must avoid forwarding or redirecting requests that could contain user
  credentials.
- Authorization transactions require CSRF protection. Use a transaction-specific `state` value
  securely bound to the user agent unless the client relies on another mechanism whose security
  properties cover the same attack. PKCE protects authorization-code redemption and can provide
  CSRF protection when the client has verified that its Authorization Server supports PKCE.
- In OpenID Connect, use a transaction-specific `nonce` and verify the corresponding ID Token
  claim to prevent ID Token replay and bind the authentication response to the initiating
  transaction. A nonce does not generally replace `state` for every OAuth CSRF threat.
- A client that interacts with multiple Authorization Servers must prevent mix-up attacks. Verify
  the authorization response's issuer using the `iss` parameter or an equivalent issuer claim.
  Distinct redirect URIs may be used when issuer identification is unavailable.

## PKCE: Proof Key for Code Exchange

Public clients using the Authorization Code Grant are susceptible to authorization-code
interception. [PKCE (RFC 7636)](https://www.rfc-editor.org/rfc/rfc7636), pronounced “pixy,” binds
an authorization request to its token request through a one-time secret called the
`code_verifier`.

PKCE was designed for native applications but is now the recommended baseline for Authorization
Code flows across client types. An attacker who steals a code cannot redeem it without the
transaction's verifier.

- Clients should use the `S256` code challenge method. The `plain` method exposes the verifier's
  value in the authorization request and should not be used where `S256` is available.
- The `code_challenge` and `code_verifier` must be transaction-specific and bound to the client
  and user agent that initiated the transaction.
- Authorization Servers must support PKCE and enforce verification when a valid
  `code_challenge` was included in the authorization request.
- Authorization Servers must prevent downgrade attacks. A token request containing a
  `code_verifier` must not be accepted unless the corresponding authorization request contained
  a `code_challenge`.
- PKCE protects authorization codes. It does not protect access or refresh tokens after issuance;
  use sender-constrained tokens or refresh-token rotation for token replay protection.

## Implicit Grant: deprecated

The Implicit Grant (`response_type=token`) is deprecated by
[RFC 9700 section 2.1.2](https://www.rfc-editor.org/rfc/rfc9700.html#section-2.1.2) and omitted from
the evolving OAuth 2.1 specification. It exposes access tokens through the browser front channel,
where they can leak through browser behavior, application code, or URL handling, and it does not
support modern sender-constraining at token issuance.

Clients should use the Authorization Code Grant with PKCE (`response_type=code`), including SPAs
and native applications. Existing applications using the Implicit Grant should migrate. An
OpenID Connect hybrid response may return an ID Token from the authorization endpoint when the
protocol requires it, but access tokens should still be obtained from the token endpoint rather
than the front channel.

## Token replay prevention

Sender-constrained tokens bind a token to client-controlled key material. A stolen token is
insufficient on its own because an attacker must also possess the corresponding private key.

### DPoP

[Demonstrating Proof of Possession (DPoP), RFC 9449](https://www.rfc-editor.org/rfc/rfc9449)
operates at the HTTP application layer:

1. The client generates a public-private key pair.
2. The client presents a signed DPoP proof to the Authorization Server when requesting a token.
3. The Authorization Server binds the token to the public key, normally through a `cnf` claim
   containing the JWK thumbprint (`jkt`).
4. For each protected-resource request, the client sends a fresh signed DPoP proof.
5. The Resource Server validates the access token, key binding, proof claims, and access-token
   hash.

DPoP does not require mutual TLS and can suit browsers, mobile clients, and other environments
where application-level keys are practical. It adds key management, proof generation, replay
tracking, and cryptographic validation to each request.

### Mutual TLS certificate-bound access tokens

[OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens (RFC 8705)](https://www.rfc-editor.org/rfc/rfc8705)
operates at the transport layer:

1. The client authenticates with a TLS client certificate during the mutual TLS handshake.
2. The Authorization Server binds the access token to the certificate, using the token's `cnf`
   claim.
3. The Resource Server verifies that the certificate presented for the connection matches the
   certificate bound to the token.

mTLS leverages TLS and PKI infrastructure and does not require an application-level proof for
every request. It does require certificate provisioning, rotation, and transport infrastructure
that preserves client-certificate authentication end to end.

### When to use sender-constrained tokens

Consider DPoP or mTLS for:

- APIs handling sensitive financial, healthcare, or personal information.
- High-value transactions and critical operations.
- Long-lived credentials where interception has an extended impact.
- Cross-organizational and B2B integrations.
- Mobile or native clients with suitable protected key storage.
- Distributed architectures where credentials traverse several network boundaries.

Sender-constraining limits token replay; it does **not** remove the need for audience restriction.
Both bearer and PoP access tokens should be issued for the minimum necessary audience, resources,
actions, and lifetime. Multi-audience tokens increase blast radius and should be avoided unless a
specific protocol design requires them and every Resource Server validates the intended audience.

Refresh tokens should either be sender-constrained or use refresh-token rotation. With rotation,
the Authorization Server issues a new refresh token on every use, invalidates the old token, and
detects reuse so it can revoke the affected token family. Combining sender-constraining and
rotation provides defense in depth.

## Access-token privilege restriction

Access-token privileges should be limited to what the client needs for the current use case. This
prevents clients and users from exceeding delegated authorization and reduces the impact of token
leakage.

### Audience restriction

The Authorization Server should associate each access token with its intended Resource Server,
preferably one Resource Server. Every Resource Server must verify on every request that the token
was issued for it and reject mismatched tokens.

Clients and Authorization Servers can use `resource` and `scope` to identify the intended
Resource Server and delegated permissions. The exact audience representation depends on the token
format and authorization profile.

### Resource and action restriction

The Authorization Server should restrict tokens to the required resources and operations. Every
Resource Server must verify that the presented token authorizes the requested action on the
requested resource. `scope` and
[Rich Authorization Requests (`authorization_details`), RFC 9396](https://www.rfc-editor.org/rfc/rfc9396)
can express these restrictions.

## Resource Owner Password Credentials Grant: do not use

The Resource Owner Password Credentials Grant must not be used. It exposes the Resource Owner's
credentials to the client, trains applications to collect passwords intended for another security
domain, and increases the credential attack surface. Use an Authorization Code flow through the
Authorization Server instead.

## Client authentication

Authorization Servers should authenticate clients whenever the client can safely hold
credentials. Prefer asymmetric methods such as mTLS or `private_key_jwt` over shared client
secrets. Asymmetric authentication avoids storing the same sensitive symmetric credential at both
the client and Authorization Server and supports independent key rotation.

Public clients cannot keep a static shared secret confidential. Their registered `client_id` is an
identifier, not an authentication credential; PKCE protects their Authorization Code flow.

## Other recommendations

- Authorization Servers must not let clients choose `client_id`, `sub`, or other claims in ways
  that could confuse client identity with Resource Owner identity.
- Use end-to-end TLS for authorization, token, and protected-resource traffic.
- Keep access-token lifetimes short and issue only the permissions needed.
- Never place access tokens in URI query parameters.
- Resource Servers should validate token issuer, audience, expiry, authorization, and
  sender-constraining when applicable.
- Avoid exposing credentials and tokens to browser history, referrer headers, application logs,
  analytics systems, or error reporting.

## Primary references

- [OAuth 2.0 Authorization Framework (RFC 6749)](https://www.rfc-editor.org/rfc/rfc6749)
- [OAuth 2.0 Security Best Current Practice (RFC 9700)](https://www.rfc-editor.org/rfc/rfc9700)
- [Bearer Token Usage (RFC 6750)](https://www.rfc-editor.org/rfc/rfc6750)
- [Proof Key for Code Exchange (RFC 7636)](https://www.rfc-editor.org/rfc/rfc7636)
- [OAuth 2.0 Mutual-TLS (RFC 8705)](https://www.rfc-editor.org/rfc/rfc8705)
- [OAuth 2.0 Demonstrating Proof of Possession (RFC 9449)](https://www.rfc-editor.org/rfc/rfc9449)
- [OAuth 2.0 Authorization Server Issuer Identification (RFC 9207)](https://www.rfc-editor.org/rfc/rfc9207)
- [OAuth 2.0 Rich Authorization Requests (RFC 9396)](https://www.rfc-editor.org/rfc/rfc9396)
- [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)
