#!/usr/bin/env bash
# Register the account id with the log mask before any AWS call prints an ARN.
set -euo pipefail

if [[ -z "${AWS_ACCOUNT_ID:-}" ]]; then
  echo "AWS_ACCOUNT_ID secret is missing" >&2
  exit 1
fi

echo "::add-mask::${AWS_ACCOUNT_ID}"

if [[ -n "${AWS_ROLE_ARN:-}" ]]; then
  echo "::add-mask::${AWS_ROLE_ARN}"
fi
