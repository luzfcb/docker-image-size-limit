#!/bin/bash

# Default values:
: "${INPUT_MAX_LAYERS:=-1}"
: "${INPUT_SHOW_CURRENT_SIZE:=false}"
: "${INPUT_DRY_RUN:=false}"

# Diagnostic output:
echo "Using image: $INPUT_IMAGE"
echo "Size limit: $INPUT_SIZE"
echo "Max layers: $INPUT_MAX_LAYERS"
echo "Show Current Size: $INPUT_SHOW_CURRENT_SIZE"
echo "Dry Run: $INPUT_DRY_RUN"
echo 'disl --version:'
disl --version
echo '================================='
echo

SHOW_CURRENT_SIZE=""
if [ "$INPUT_SHOW_CURRENT_SIZE" = "true" ]; then
  SHOW_CURRENT_SIZE="--current"
fi

DRY_RUN=""
if [ "$INPUT_DRY_RUN" = "true" ]; then
  DRY_RUN="--dry-run"
fi


# Runs disl:
output=$(disl "$INPUT_IMAGE" "$INPUT_SIZE" --max-layers="$INPUT_MAX_LAYERS" "$SHOW_CURRENT_SIZE" "$DRY_RUN")
status="$?"

# Sets the output variable for Github Action API:
# See: https://help.github.com/en/articles/development-tools-for-github-action
echo "output=$output" >> $GITHUB_OUTPUT
echo '================================'
echo

# Fail the build in case status code is not 0:
if [ "$status" != 0 ]; then
  echo 'Failing with output:'
  echo "$output"
  echo "Process failed with the status code: $status"
  exit "$status"
fi
