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

@test "creates log streams within groups for Kubernetes namespaces" {
  expected="$RANDOM"
  curl -v "$ADDRESS/echo?log=$expected"
  pod=$(kubectl \
    get pod \
    --field-selector=status.phase=Running \
    --selector=app=echoserver \
    -n acceptance \
    --output=name \
    | cut -d'/' -f2)
  logs=$(aws \
    --region us-east-1 \
    logs \
    get-log-events \
    --log-group-name "/flightdeck/acceptance" \
    --log-stream-name "$pod.echoserver" \
    --query 'events[*].[message]' \
      --output text)

  if ! echo "$logs" | grep -q "log=$expected"; then
    echo "Failed to find log for test request." >&2
    echo >&2
    echo "Test request was: GET /echo?log=$expected" >&2
    echo >&2
    echo "Found log entries" >&2
    echo "$logs" >&2
    false
  fi
}
