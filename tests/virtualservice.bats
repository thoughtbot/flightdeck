#!/usr/bin/env bats

@test "routes to the echo service" {
  response=$(curl "$ADDRESS/echo?hello")
  if ! echo "$response" | grep -q "query=hello"; then
    echo "Invalid echo response:\n$response"
    false
  fi
}
