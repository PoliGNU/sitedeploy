#!/usr/bin/env bats

# First run `kichen converge` to start the server

@test "Should access PoliGNU webpage" {
  run bash -c "curl --insecure https://localhost:8443/ | grep '<html>'"
  [ "$status" -eq 0 ]
  run bash -c "curl --insecure https://localhost:8443/ | grep PoliGNU"
  [ "$status" -eq 0 ]
}

