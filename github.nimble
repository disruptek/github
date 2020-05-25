version = "2.0.3"
author = "disruptek"
description = "github api"
license = "MIT"
requires "nim >= 1.0.6 & < 2.0.0"
requires "npeg >= 0.20.0 & < 0.23.0"
#requires "https://github.com/disruptek/rest.git >= 1.0.0 & < 2.0.0"
requires "https://github.com/disruptek/rest.git >= 1.0.5 & < 2.0.0"

srcDir = "src"

proc execCmd(cmd: string) =
  echo "execCmd:" & cmd
  exec cmd

proc execTest(test: string) =
  execCmd "nim c           -f -r " & test
  execCmd "nim c   -d:release -r " & test
  execCmd "nim c   -d:danger  -r " & test
  execCmd "nim cpp            -r " & test
  execCmd "nim cpp -d:danger  -r " & test
  when NimMajor >= 1 and NimMinor >= 1:
    execCmd "nim c   --gc:arc -r " & test
    execCmd "nim cpp --gc:arc -r " & test

task test, "run tests for travis":
  execTest("tests/tgithub.nim")
