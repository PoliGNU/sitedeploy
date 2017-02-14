#!/usr/bin/env bats

# First run `kichen converge` to start the server
# This is runned on the vagrant HOST, not the vagrant GUEST.

@test "Should access PoliGNU webpage" {
  run bash -c "curl --insecure https://localhost/ | grep '<html>'"
  [ "$status" -eq 0 ]
  run bash -c "curl --insecure https://localhost/ | grep PoliGNU"
  [ "$status" -eq 0 ]
}

