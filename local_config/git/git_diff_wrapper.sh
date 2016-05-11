#!/bin/bash
# diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode
#/usr/bin/colordiff --side-by-side --suppress-common-lines --ignore-all-space "$2" "$5" | cat
git diff "$2" "$5" | /usr/bin/colordiff --side-by-side --suppress-common-lines --ignore-all-space #| cat
#/usr/bin/colordiff -ydw "$2" "$5" | cat
#/usr/bin/diff "$2" "$5" | /home/ub2/.scripts/ENV/bin/cdiff -s -l -c 'always'
