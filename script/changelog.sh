#!/usr/bin/env bash

function show_help() {
  echo "Usage: changelog.sh [options]"
  echo "Generates a changelog from git history, ommitting commit messages that"
  echo "  are merges or contain the following: \"$skip_tag\""
  echo
  echo "Format:"
  echo "YYYY-MM-DD: commit subject [committer name]"
  echo
  echo "Options:"
  echo "-v                   Verbose output (i.e. include full commit messages)"
  echo "-r <since>..<until>  Range of commits to query, see \`git log\` for more"
  echo "                       defaults to most recent version tag (i.e. \"`default_range`\")"
  echo "-b                   Add a banner to the output"
  echo "-p                   Specify the working directory of the repository (default: \"$repository_path\")"
}

verbose=0
range_parameter=0
banner=0
skip_tag="\[log skip\]"
repository_path="./"

function default_range() {
  local latest_version_tag=`cd $repository_path && git describe --abbrev=0 --tags | tail -1`
  # a ".." range tag causes the `git log` command to fail
  if [ -z "$latest_version_tag" ]; then
    echo ''
  else
    echo "$latest_version_tag.."
  fi
}

while getopts "h?bvp:r:" opt; do
  case $opt in
    h|\?)
      show_help
      exit 0
    ;;
    b )
      banner=1
    ;;
    v )
      verbose=1
    ;;
    r )
      range_parameter=$OPTARG
    ;;
    p )
      repository_path=$OPTARG
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
  # Subject/author line wraps at 80 characters, no padding
  local format_subject_author="%w(80,0,0)%ad: %s [%cN]%n"
  if [ $verbose = 0 ]; then
    echo "tformat:$format_subject_author"
  else
    echo "tformat:$format_subject_author%n%w(72,4,4)%b"
  fi
}
pretty_format=`get_format`

function changelog() {
  # Get a list of all SHA1 commits
  #   Filter the list to exclude all SHA1 commits with $skip_tag
  #   Then requery the log and output format
  cd $repository_path && git log $range --no-merges --format=%H $@ |
    grep -v -f <(cd $repository_path && git log $range --no-merges --format=%H --grep="$skip_tag" $@) |
    git log $range --no-merges --pretty="$pretty_format" --date=short --stdin --no-walk
}

function main() {
  if [ $banner = 1 ]; then
    echo $range
    echo $range | sed -e 's/./-/g'
    echo ''
  fi
  changelog
}

main