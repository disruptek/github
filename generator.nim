import std/os
import std/macros
import std/strutils
import std/httpcore
import std/json

import rest

from pkg/openapi/spec import Scheme, toNimNode, hash
import pkg/openapi/codegen

const
  OPENAPIIN* {.strdefine.} = os.getEnv("OPENAPIIN")
  OPENAPIOUT {.strdefine.} = os.getEnv("OPENAPIOUT")

generate anApi, OPENAPIIN, OPENAPIOUT:
  #generator.forms.excl InHeader
  generator.recallable = ident"hook"
  generator.imports.add ident"rest"
  generator.imports.add ident"os"
  generator.imports.add ident"uri"
  generator.imports.add ident"httpcore"

render anApi:
  export rest

  method hook(call: OpenApiRestCall; url: Uri; input: JsonNode;
              body: string): Recallable
    {.base.} =
    var
      headers = massageHeaders(input.getOrDefault("header")).newHttpHeaders
    let
      token = os.getEnv("GITHUB_TOKEN", "")
    if not headers.hasKey("Authorization") and token.len > 0:
      headers.add "Authorization", "token " & token
    if headers.hasKey "Accept":
      headers.del "Accept"
    headers.add "Accept", "application/vnd.github.v3+json"
    result = newRecallable(call, url, headers, body)

when not defined(ssl):
  {.error: "use ssl".}

when NimMajor < 1:
  {.error: "use nim-1.0".}
