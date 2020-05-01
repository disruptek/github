import std/httpclient
import std/asyncdispatch
import std/unittest

import github

suite "github":
  test "emojis":
    let
      req = getEmojis.call(header = nil)
      response = waitfor req.retry(tries=3)
    check response.code.is2xx
    discard waitfor response.body
    check response.body.read.len > 0
