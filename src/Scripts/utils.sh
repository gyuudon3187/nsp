# Utils Script for New Swing Project (NSP)
# Created by Daniel Dahlberg
# License: MIT
# Description: This script contains utility functions for checking usage, validating flags, and printing verbose messages.

# Check script usage and print error if incorrect
check_usage() {
  local -r USAGE="Usage: $0 ${@: -1}"
  shift

  if [ "$#" -lt 1 ]; then
    echo $USAGE
    exit 1
  fi
}

# Validate flags and print error if invalid
check_flags() {
  for arg in "$@"; 
  do
    if [[ "$arg" != -* ]]; then
      echo "Error: Argument '$arg' is not a valid flag."
      exit 1
    fi
  done
}

# Print verbose messages if VERBOSE is enabled
print_verbose() {
  local -r MSG="$1"

  if [ "$VERBOSE" = true ]; then
    echo "Verbose: $MSG"
  fi
}

# Handles errors
handle_error() {
  local -r LINE="$1"
  local -r MSG="${2:-Unknown error}"
  local -r CODE="${3:-1}"

  echo "Error on or near line ${LINE}: ${MSG}."
  echo "Exiting with status ${CODE}."
  exit "${CODE}"
}

# Removes a specified directory for cleanup
cleanup() {
  local -r DIR=$1
  local -r MSG=${2:-Cleaning up $DIR.}
  local -r CODE=${3:-0}

  echo $MSG
  rm -rf $DIR
  echo "Cleanup completed."
  exit $CODE
}

# Create a temprorary directory and ensure it is removed when done
create_temp_dir() {
  readonly TEMP_DIR=$(mktemp -d)
  
  if [ ! -d $TEMP_DIR ]; then
    local -r MSG="Failed to create temporary directory."
    handle_error $LINENO "$MSG"
  fi

  trap 'cleanup $TEMP_DIR' EXIT
}

# Ensure sourced functions are valid
check_source_success() {
  local -r FUNCTION_NAMES=("$@")
  for fn in "${FUNCTION_NAMES[@]}"; do
    if [[ $(type -t "$fn") != "function" ]]; then
      echo "Error: '$fn' is not a valid function." >&2
      exit 1
    fi
  done
}
