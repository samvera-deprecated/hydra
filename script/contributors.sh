#!/usr/bin/env sh

#
# Auto-generate a list of contributors for a given Git repository.
#
# At the root of a project:
#
#   ./script/contributors.sh
#

echo "Contributors to this project:" > CONTRIBUTORS.md
echo >> CONTRIBUTORS.md
git shortlog -s | cut -c '8-200' | awk '{print "* ", $0}' >> CONTRIBUTORS.md
echo >> CONTRIBUTORS.md