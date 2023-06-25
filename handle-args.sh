#!/usr/bin/env bash

report() {
	touch /tmp/openapi-std-out
	touch /tmp/openapi-std-err

        echo Args: $1	
	EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
	echo 'std-out<<'$EOF >> "$GITHUB_OUTPUT"
	cat /tmp/openapi-std-out >> "$GITHUB_OUTPUT" 
	echo "$EOF" >> "$GITHUB_OUTPUT"
	EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
	echo 'std-err<<'$EOF >> "$GITHUB_OUTPUT"
	cat /tmp/openapi-std-err >> "$GITHUB_OUTPUT"
	echo "$EOF" >> "$GITHUB_OUTPUT"

	echo '## Openapi `'$1'`'>> "$GITHUB_STEP_SUMMARY"
	echo '```'>> "$GITHUB_STEP_SUMMARY"
	cat /tmp/openapi-std-out >> "$GITHUB_STEP_SUMMARY"
	cat /tmp/openapi-std-err >> "$GITHUB_STEP_SUMMARY"
	echo '```'>> "$GITHUB_STEP_SUMMARY"
}
trap "report \"$1\"" ERR

set -e
set -o pipefail


cd /github/workspace
echo "redoc-cli version: $(openapi --version)"
openapi $1 > >(tee -a /tmp/openapi-std-out) 2> >(tee -a /tmp/openapi-std-err >&2)
# only 1 argument is passed but GHA
# We need to preserve stdout for output + report

report "$1"



