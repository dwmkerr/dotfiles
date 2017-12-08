#!/usr/bin/env bash

# Log into to the locally configured OpenShift instance.
function oslogin() {
  oc login $OPENSHIFT_URL -u $OPENSHIFT_USER -p $OPENSHIFT_PASS --insecure-skip-tls-verify
  oc project $1
}

function podlogs() {
  echo "Getting logs for $1 for the last $2 duration"
  oc logs -f --since=$2 `oc get pods | grep $1 | grep 'Running' | grep -Ev 'deploy' | awk '{print $1}'`
}
