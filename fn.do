fn.root() { printf "%s\n" "${XDG_CONFIG_HOME:-$HOME/.config}/zsh" }
fn.slot_file() { printf "%s\n" "$(fn.root)/fn.%s.sh" "$1" }
fn.active_file() { printf "%s\n" "$(fn.root)/fn.active" }

fn.read_active() {
  local f="$(fn.active_file)"
  local s
  s="$(<"$f" 2>/dev/null)"
  [[ "$s" == "a" || "$s" == "b" ]] || s="a"
  printf "%s\n" "$s"
}

fn.write_active() {
  local s="$1"
  [[ "$s" == "a" || "$s" == "b" ]] || return 1
  local f="$(fn.active_file)"
  mkdir -p "$(fn.root)" 2>/dev/null
  printf "%s\n" "$s" >| "$f"
}

fn.other() {
  local s="${1:-$(fn.read_active)}"
  [[ "$s" == "a" ]] && printf "b\n" || printf "a\n"
}

fn.ensure_slots() {
  local ra="$(fn.slot_file a)"
  local rb="$(fn.slot_file b)"
  mkdir -p "$(fn.root)" 2>/dev/null
  [[ -f "$ra" ]] || printf "%s\n" ":" >| "$ra"
  [[ -f "$rb" ]] || printf "%s\n" ":" >| "$rb"
  [[ -f "$(fn.active_file)" ]] || fn.write_active a
}

fn.validate_slot() {
  local s="$1"
  local f="$(fn.slot_file "$s")"
  [[ -f "$f" ]] || return 1
  zsh -o err_return -o no_unset -c "source \"$f\"" >/dev/null 2>&1
}

fn.validate_both() {
  fn.validate_slot a && fn.validate_slot b
}

fn.best_active() {
  local a_ok=1 b_ok=1
  fn.validate_slot a; a_ok=$?
  fn.validate_slot b; b_ok=$?
  if [[ $a_ok -eq 0 && $b_ok -ne 0 ]]; then printf "a\n"; return 0; fi
  if [[ $b_ok -eq 0 && $a_ok -ne 0 ]]; then printf "b\n"; return 0; fi
  if [[ $a_ok -eq 0 && $b_ok -eq 0 ]]; then printf "%s\n" "$(fn.read_active)"; return 0; fi
  return 1
}

fn.load() {
  fn.ensure_slots
  local s
  s="$(fn.best_active)" || { print "fn slots broken: neither a nor b loads"; return 1; }
  fn.write_active "$s" >/dev/null 2>&1 || :
  source "$(fn.slot_file "$s")"
}

fn.edit() {
  fn.ensure_slots
  local active="$(fn.read_active)"
  local target="$(fn.other "$active")"
  local f="$(fn.slot_file "$target")"
  local tmp="$f.tmp.$$"

  /bin/cp -p "$f" "$tmp" 2>/dev/null || printf "%s\n" ":" >| "$tmp"
  ${EDITOR:-vi} "$tmp" || { rm -f "$tmp"; print "try again"; return 1; }

  zsh -o err_return -o no_unset -c "source \"$tmp\"" >/dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    rm -f "$tmp"
    print "invalid: would not load"
    print "try again"
    return 1
  fi

  mv -f "$tmp" "$f" || { rm -f "$tmp"; print "try again"; return 1; }
  fn.write_active "$target" || { print "try again"; return 1; }
  print "switched to: $target"
}

fn.status() {
  fn.ensure_slots
  local a_ok b_ok
  fn.validate_slot a; a_ok=$?
  fn.validate_slot b; b_ok=$?
  print "active: $(fn.read_active)"
  print "a: $([[ $a_ok -eq 0 ]] && echo OK || echo BAD)  $(fn.slot_file a)"
  print "b: $([[ $b_ok -eq 0 ]] && echo OK || echo BAD)  $(fn.slot_file b)"
}

fn.rollback() {
  fn.ensure_slots
  local active="$(fn.read_active)"
  local other="$(fn.other "$active")"
  fn.validate_slot "$other" || { print "other slot invalid"; print "try again"; return 1; }
  fn.write_active "$other" || { print "try again"; return 1; }
  print "switched to: $other"
  print "try again"
}