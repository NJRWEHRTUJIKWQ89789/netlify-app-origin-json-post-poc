# Public `app.netlify.com` JSON POST proof

This repository contains a non-destructive proof that Netlify's production
Bitbucket Server helper will return a controlled, Forms-stored JSON object from
the `app.netlify.com` origin without a Netlify session.

## Verified endpoint

```text
POST https://app.netlify.com/.netlify/functions/bitbucket-self-hosted
```

The verifier disables curl configuration, sends no Cookie or Authorization
header, supplies `Origin: https://example.org`, and requires all of these:

- HTTP `200`;
- valid JSON;
- the exact expected SHA-256 for the 176-byte owned fixture.

```sh
./verify-public-no-cookie.sh
```

Expected result:

```text
PASS status=200 sha256=8c7b5c2dc5338aa032aabade6688c5e15bf6b99bad4a298f11da0d33ed2383cc endpoint=https://app.netlify.com/.netlify/functions/bitbucket-self-hosted
```

## Browser proof

Open `poc-form.html` and select **Open app.netlify.com JSON proof**. The browser
navigates by ordinary `enctype=text/plain` form POST to the endpoint above.
The final document is an `app.netlify.com` JSON response containing:

```json
{"marker":"NFX_SERVER_CLIENT_DIFF","value":[1,true,null]}
```

`poc-fetch.js` is the equivalent same-origin fetch proof. It explicitly sets
`credentials: "omit"`.

## Exact boundary

- Public HTTP access is proven for clients capable of POST.
- A plain GET returns `412`; this is not a normal shareable GET URL.
- Cross-origin forms can navigate to the response.
- Cross-origin JavaScript cannot read the response because it has no
  `Access-Control-Allow-Origin` header.
- This proves a public app-origin JSON source. It does not by itself prove XSS.

Only an owned, harmless Forms attachment is used. No account data, private
submission, mutation, or credential is accessed.
