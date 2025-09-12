#!/bin/zsh

set -e

# Tests for the back_up function in functions.zsh
# - Stubs gsutil to capture rsync calls instead of executing
# - Patches the function at runtime to use a temporary Volumes dir
# - Verifies filtering of "Macintosh HD" on non-full backups

TESTDIR=$(mktemp -d)
GSUTIL_LOG="$TESTDIR/gsutil.log"
VOLDIR="$TESTDIR/Volumes"
mkdir -p "$VOLDIR"

# Create fake volumes (one with a space like real "Macintosh HD")
mkdir -p "$VOLDIR/Macintosh HD"
mkdir -p "$VOLDIR/USB1"

# Source the real functions
source ./functions.zsh

# Patch back_up to use our test volumes directory instead of /Volumes
local __orig_def
__orig_def=$(functions back_up)
local __patched_def
# Replace the glob target "\"/Volumes/\"*" with our test dir
__patched_def=$(print -r -- "$__orig_def" | sed -e "s#\"/Volumes/\"\*#\"$VOLDIR/\"*#")
eval "$__patched_def"

# Override gsutil to capture rsync invocations
gsutil() {
  print -r -- "gsutil $*" >> "$GSUTIL_LOG"
}

fail() { print -r -- "FAIL: $1"; exit 1 }
pass() { print -r -- "PASS: $1" }

reset_logs() {
  : > "$GSUTIL_LOG"
}

# Test 1: Non-full backup excludes "Macintosh HD"
reset_logs
print -r -- n | back_up

# Ensure USB1 is targeted
rg -q "imgfunnels.com/USB1" "$GSUTIL_LOG" || fail "Expected USB1 backup command in gsutil log"
# Ensure Macintosh HD is not targeted
if rg -q "imgfunnels.com/Macintosh HD" "$GSUTIL_LOG"; then
  fail "Did not expect Macintosh HD in non-full backup"
fi

# Ensure exclude pattern is present
rg -q -- "node_modules" "$GSUTIL_LOG" || fail "Exclude pattern (node_modules) not found in rsync command"

pass "Non-full backup filters system volume and includes excludes"

# Test 2: Full backup includes "Macintosh HD"
reset_logs
print -r -- y | back_up

rg -q "imgfunnels.com/USB1" "$GSUTIL_LOG" || fail "Expected USB1 backup command in full backup"
rg -q "imgfunnels.com/Macintosh HD" "$GSUTIL_LOG" || fail "Expected Macintosh HD in full backup"

pass "Full backup includes system volume"

print -r -- "PASS: back_up tests completed successfully"
