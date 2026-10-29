(async () => {
  const endpoint =
    "https://app.netlify.com/.netlify/functions/bitbucket-self-hosted";

  const formsStoredObject =
    "https://d33wubrfki0l68.cloudfront.net/" +
    "96e4811e-62d7-41be-85d5-3e502ffe41c2/" +
    "NFX_ISOLATED_DIFF_20261029170632291-json_object_literal_svg.json";

  const response = await fetch(endpoint, {
    method: "POST",
    credentials: "omit",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      url: formsStoredObject,
      method: "GET",
      token: "harmless-owned-fixture",
      payload: null,
    }),
  });

  const data = await response.json();
  console.log({
    status: response.status,
    responseURL: response.url,
    data,
  });
})().catch(console.error);
