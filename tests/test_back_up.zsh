#!/bin/zsh

set -e

# Tests for the back_up function in functions.zsh
# - Stubs gsutil to capture rsync calls instead of executing
# - Patches the function at runtime to use a temporary Volumes dir
# - Verifies selection + isolation behavior and --full inclusion

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

###############################
# Test 1: Select USB1 (default list excludes system) and isolate
###############################
reset_logs
# With --non-full default, only USB1 shows, so select 1 then answer 'y' to isolate
print -r -- "1\ny" | back_up

# Ensure USB1 isolated path is targeted
rg -q "imgfunnels.com/USB1" "$GSUTIL_LOG" || fail "Expected USB1 backup command in gsutil log"
# Ensure Macintosh HD is not targeted
if rg -q "imgfunnels.com/Macintosh HD" "$GSUTIL_LOG"; then
  fail "Did not expect Macintosh HD in non-full selection"
fi
# Ensure exclude pattern is present
rg -q -- "node_modules" "$GSUTIL_LOG" || fail "Exclude pattern (node_modules) not found in rsync command"
pass "Selected USB1 with isolation in non-full mode"

###############################
# Test 2: With --full, select Macintosh HD and isolate
###############################
reset_logs
# In sorted order, "Macintosh HD" should be option 1; answer 'y' to isolate
print -r -- "1\ny" | back_up --full
rg -q "imgfunnels.com/Macintosh HD" "$GSUTIL_LOG" || fail "Expected Macintosh HD in full mode selection"
pass "Full mode shows system volume; isolated path used"

###############################
# Test 3: Non-isolated path upload (USB1 -> bucket root)
###############################
reset_logs
print -r -- "1\nn" | back_up
# For non-full, only USB1 is listed as 1; ensure destination is bucket root
rg -q "gsutil rsync" "$GSUTIL_LOG" || fail "Expected an rsync invocation"
rg -q "gs://imgfunnels.com" "$GSUTIL_LOG" || fail "Expected bucket root in destination"
if rg -q "gs://imgfunnels.com/USB1" "$GSUTIL_LOG"; then
  fail "Expected non-isolated destination without /USB1 suffix"
fi
pass "Non-isolated upload goes to bucket root"

print -r -- "PASS: back_up tests completed successfully"
