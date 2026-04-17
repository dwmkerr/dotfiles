configure_aws_profile() {
  local name="configure_aws_profile"
  if [[ "$1" == "-h" || -z "$1" ]]; then
    echo "usage: ${name} <profile_name>"
    echo "  Ensures the given AWS profile exists and has working credentials."
    echo "  If already configured and credentials are valid, returns immediately (noop)."
    echo "  Otherwise runs 'aws configure --profile <profile_name>' and verifies the result."
    return 0
  fi

  local profile="$1"

  echo -n "checking aws profile '${profile}'... "
  if aws sts get-caller-identity --profile "${profile}" >/dev/null 2>&1; then
    echo "configured, credentials valid"
    return 0
  fi
  echo "not configured or credentials invalid"

  echo "running: aws configure --profile ${profile}"
  aws configure --profile "${profile}"

  # Verify after configuration - `aws configure` itself does not validate creds.
  if aws sts get-caller-identity --profile "${profile}" >/dev/null 2>&1; then
    echo "aws profile '${profile}' configured and credentials verified"
    return 0
  fi

  echo "error: aws profile '${profile}' credentials are invalid (aws sts get-caller-identity failed)"
  return 1
}
