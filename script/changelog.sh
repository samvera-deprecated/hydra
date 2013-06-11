#!/usr/bin/env bash

function show_help() {
  echo "Usage: changelog.sh [options]"
  echo "Generates a changelog from git history, ommitting commit messages that"
  echo "  are merges or contain the following: \"$skip_tag\""
  echo
  echo "Format:"
  echo "commit subject [committer name]"
  echo
  echo "Options:"
  echo "-v                   Verbose output (i.e. include full commit messages)"
  echo "-r <since>..<until>  Range of commits to query, see \`git log\` for more"
  echo "                       defaults to most recent version tag (i.e. \"`default_range`\")"
}

verbose=0
range_parameter=0
skip_tag="\[log skip\]"

function default_range() {
  local latest_version_tag=`git tag | grep ^v | sort | tail -1`
  # a ".." range tag causes the `git log` command to fail
  if [ -z "$latest_version_tag" ]; then
    echo ''
  else
    echo "$latest_version_tag.."
  fi
}

while getopts "h?vr:" opt; do
  case $opt in
    h|\?)
      show_help
      exit 0
    ;;
    v )
      verbose=1
    ;;
    r )
      range_parameter=$OPTARG
    ;;
  esac
done;


function get_range() {
  if [ $range_parameter = 0 ]; then
    default_range
  else
    echo $range_parameter
  fi
}

range=`get_range`

function get_format() {
  if [ $verbose = 0 ]; then
    echo "tformat:%s [%cN]"
  else
    echo "tformat:%s [%cN]%n%w(72,4,4)%b"
  fi
}
pretty_format=`get_format`

function main() {
  # Get a list of all SHA1 commits
  #   Filter the list to exclude all SHA1 commits with $skip_tag
  #   Then requery the log and output format
  git log $range --no-merges --format=%H $@ |
    grep -v -f <(git log $range --no-merges --format=%H "--grep=$skip_tag" $@) |
    git log $range --no-merges --pretty="$pretty_format" --stdin --no-walk
}

main