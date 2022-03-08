#!/usr/bin/env bats

@test "deploys fluent bit on each node" {
  pods=$(kubectl \
    --namespace flightdeck \
    get pod \
    --field-selector=status.phase=Running \
    --selector=app.kubernetes.io/name=fluent-bit \
    --output jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' \
    | sort)
  nodes=$(kubectl \
    --namespace flightdeck \
    get node \
    --output=name \
    | sed 's|^node/||' \
    | sort)

  if [ "$pods" != "$nodes" ]; then
    echo "Found nodes:" >&2
    echo "$nodes" >&2
    echo >&2
    echo "Found Fluent Bit pods on nodes:" >&2
    echo "$pods" >&2
    echo "$pods" > /tmp/podlist
    echo "$nodes" > /tmp/nodelist
    echo >&2
    echo "Difference:" >&2
    diff /tmp/nodelist /tmp/podlist  >&2
    false
  fi
}
