#!/bin/bash

# Claude Code Status Line - Nerd Font icons + gradient progress bars
# Reads JSON from stdin, outputs ANSI-colored status

set -euo pipefail

# ── Colors ──────────────────────────────────
GRAY="\033[38;2;74;88;92m" # #4A585C
RESET="\033[0m"
BOLD="\033[1m"

# Gradient stops: green(#97C9C3) → yellow(#E5C07B) → red(#E06C75)
# RGB values for interpolation
G_R=151 G_G=201 G_B=195 # green
Y_R=229 Y_G=192 Y_B=123 # yellow
R_R=224 R_G=108 R_B=117 # red

# ── macOS compatibility: use gdate if available ──
DATE_CMD="date"
if command -v gdate &>/dev/null; then
  DATE_CMD="gdate"
fi

# ── Read stdin JSON ─────────────────────────────
input=$(cat)

eval "$(echo "$input" | jq -r '
{
  model_name: (if (.model | type) == "object" then (.model.display_name // .model.id // "Claude") else (.model // "Claude") end),
  ctx_percent: (.context_window.used_percentage // 0),
  cwd: (.workspace.current_dir // .cwd // "")
} | to_entries | .[] | "\(.key)=\(.value | @sh)"')"

# Shorten model name: "Claude Opus 4.6 (1M context)" → "Opus 4.6"
short_model="${model_name#Claude }"
short_model="${short_model%% (*}"

# Get git branch
git_branch=""
if [[ -n "$cwd" ]]; then
  git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "")
fi

# ── Gradient progress bar (━/─, 10 segments) ───
# Fixed gradient across all 10 positions: green → yellow → red
# Filled segments show the color at their position in the gradient
progress_bar() {
  local pct=$1
  local filled=$(((pct + 9) * 10 / 100))
  [[ $pct -eq 0 ]] && filled=0
  [[ $filled -gt 10 ]] && filled=10

  local bar=""
  for ((i = 0; i < 10; i++)); do
    if [[ $i -lt $filled ]]; then
      # Position in the full 10-segment gradient (0-1000)
      local t=$((i * 1000 / 9))
      local r g b
      if [[ $t -le 500 ]]; then
        # green → yellow (first half)
        local t2=$((t * 2))
        r=$((G_R + (Y_R - G_R) * t2 / 1000))
        g=$((G_G + (Y_G - G_G) * t2 / 1000))
        b=$((G_B + (Y_B - G_B) * t2 / 1000))
      else
        # yellow → red (second half)
        local t2=$(((t - 500) * 2))
        r=$((Y_R + (R_R - Y_R) * t2 / 1000))
        g=$((Y_G + (R_G - Y_G) * t2 / 1000))
        b=$((Y_B + (R_B - Y_B) * t2 / 1000))
      fi
      bar+="\033[38;2;${r};${g};${b}m━"
    else
      bar+="${GRAY}─"
    fi
  done
  bar+="${RESET}"
  echo -ne "$bar"
}

# ── Remaining bar (reversed gradient: red → yellow → green) ──
# More remaining = green (safe), less remaining = red (warning)
remaining_bar() {
  local pct=$1
  local filled=$(((pct + 9) * 10 / 100))
  [[ $pct -eq 0 ]] && filled=0
  [[ $filled -gt 10 ]] && filled=10

  local bar=""
  for ((i = 0; i < 10; i++)); do
    if [[ $i -lt $filled ]]; then
      local t=$((i * 1000 / 9))
      local r g b
      if [[ $t -le 500 ]]; then
        # red → yellow (first half)
        local t2=$((t * 2))
        r=$((R_R + (Y_R - R_R) * t2 / 1000))
        g=$((R_G + (Y_G - R_G) * t2 / 1000))
        b=$((R_B + (Y_B - R_B) * t2 / 1000))
      else
        # yellow → green (second half)
        local t2=$(((t - 500) * 2))
        r=$((Y_R + (G_R - Y_R) * t2 / 1000))
        g=$((Y_G + (G_G - Y_G) * t2 / 1000))
        b=$((Y_B + (G_B - Y_B) * t2 / 1000))
      fi
      bar+="\033[38;2;${r};${g};${b}m━"
    else
      bar+="${GRAY}─"
    fi
  done
  bar+="${RESET}"
  echo -ne "$bar"
}

# ── Fetch usage data (with cache) ──────────────
CACHE_FILE="/tmp/claude-usage-cache.json"
LOCK_FILE="/tmp/claude-usage-cache.lock"
CACHE_TTL=60

five_pct=0
five_reset_epoch=0
seven_pct=0
seven_reset_epoch=0

load_cache() {
  [[ -f "$CACHE_FILE" ]] || return 1
  five_pct=$(jq -r '.five_hour_pct // 0' "$CACHE_FILE" 2>/dev/null)
  five_reset_epoch=$(jq -r '.five_hour_reset_epoch // 0' "$CACHE_FILE" 2>/dev/null)
  seven_pct=$(jq -r '.seven_day_pct // 0' "$CACHE_FILE" 2>/dev/null)
  seven_reset_epoch=$(jq -r '.seven_day_reset_epoch // 0' "$CACHE_FILE" 2>/dev/null)
  return 0
}

fetch_usage() {
  local now
  now=$(date +%s)

  if [[ -f "$CACHE_FILE" ]]; then
    local cache_time
    cache_time=$(jq -r '.cached_at // 0' "$CACHE_FILE" 2>/dev/null)
    local age=$((now - cache_time))
    if [[ $age -lt $CACHE_TTL ]]; then
      load_cache
      return 0
    fi
  fi

  if [[ -f "$LOCK_FILE" ]]; then
    local lock_time
    lock_time=$(cat "$LOCK_FILE" 2>/dev/null || echo 0)
    if [[ $((now - lock_time)) -lt 30 ]]; then
      load_cache
      return 0
    fi
  fi
  echo "$now" >"$LOCK_FILE"

  local cred_file="$HOME/.claude/.credentials.json"
  if [[ ! -f "$cred_file" ]]; then
    rm -f "$LOCK_FILE"
    load_cache
    return 0
  fi
  local token
  token=$(jq -r '.claudeAiOauth.accessToken // ""' "$cred_file")
  if [[ -z "$token" ]]; then
    rm -f "$LOCK_FILE"
    load_cache
    return 0
  fi

  local http_code
  http_code=$(curl -s -o /tmp/claude-usage-resp.json -w '%{http_code}' --max-time 5 \
    -H "Authorization: Bearer $token" \
    -H "anthropic-beta: oauth-2025-04-20" \
    "https://api.anthropic.com/api/oauth/usage" 2>/dev/null) || http_code=0

  rm -f "$LOCK_FILE"

  if [[ "$http_code" != "200" ]]; then
    rm -f /tmp/claude-usage-resp.json
    load_cache
    return 0
  fi

  local resp
  resp=$(cat /tmp/claude-usage-resp.json)
  rm -f /tmp/claude-usage-resp.json

  local f_util f_reset s_util s_reset
  f_util=$(echo "$resp" | jq -r '.five_hour.utilization // 0')
  f_reset=$(echo "$resp" | jq -r '.five_hour.resets_at // ""')
  s_util=$(echo "$resp" | jq -r '.seven_day.utilization // 0')
  s_reset=$(echo "$resp" | jq -r '.seven_day.resets_at // ""')

  five_pct=$(printf "%.0f" "$f_util")
  seven_pct=$(printf "%.0f" "$s_util")

  local f_reset_epoch=0 s_reset_epoch=0
  if [[ -n "$f_reset" && "$f_reset" != "null" ]]; then
    f_reset_epoch=$($DATE_CMD -d "$f_reset" '+%s' 2>/dev/null || echo 0)
  fi
  if [[ -n "$s_reset" && "$s_reset" != "null" ]]; then
    s_reset_epoch=$($DATE_CMD -d "$s_reset" '+%s' 2>/dev/null || echo 0)
  fi

  five_reset_epoch=$f_reset_epoch
  seven_reset_epoch=$s_reset_epoch

  cat >"$CACHE_FILE" <<CACHE
{"cached_at":$now,"five_hour_pct":$five_pct,"five_hour_reset_epoch":$f_reset_epoch,"seven_day_pct":$seven_pct,"seven_day_reset_epoch":$s_reset_epoch}
CACHE
}

fetch_usage 2>/dev/null || true

# ── Format remaining time ─────────────────────
format_remaining() {
  local reset_epoch=$1
  local now
  now=$(date +%s)
  local diff=$((reset_epoch - now))
  if [[ $diff -le 0 ]]; then
    echo "now"
    return
  fi
  local days=$((diff / 86400))
  local hours=$(((diff % 86400) / 3600))
  local mins=$(((diff % 3600) / 60))
  if [[ $days -gt 0 ]]; then
    echo "${days}d${hours}h"
  elif [[ $hours -gt 0 ]]; then
    echo "${hours}h${mins}m"
  else
    echo "${mins}m"
  fi
}

# ── Line 1: Model │ Context │ Branch ───────────
ctx_percent=${ctx_percent%.*} # truncate decimal
sep="${GRAY}│${RESET}"

ctx_bar=$(progress_bar "$ctx_percent")
model_pad=$(printf "%-17s" "$short_model")
ctx_pct_fmt=$(printf "%5s" "${ctx_percent}%")
line1="  ${BOLD}󰚩 ${model_pad}${RESET}${sep} 󰍛 ${ctx_bar} ${ctx_pct_fmt}"

if [[ -n "$git_branch" ]]; then
  line1+=" ${sep}  ${git_branch}"
fi

# ── Line 2: 5h and 7d rate limits (usage) ──────
five_bar=$(progress_bar "$five_pct")
seven_bar=$(progress_bar "$seven_pct")
# Right-align for 5h (before │), left-align for 7d (end of line)
five_pct_fmt=$(printf "%5s" "${five_pct}%")
seven_pct_fmt=$(printf "%5s" "${seven_pct}%")

line2="  󰔛 ${five_bar} ${five_pct_fmt} ${sep} 󰃭 ${seven_bar} ${seven_pct_fmt}"

# ── Line 3: 5h and 7d remaining (time-based) ──
now_l3=$(date +%s)

# 5h window = 18000s
if [[ $five_reset_epoch -gt 0 ]]; then
  five_rem_secs=$((five_reset_epoch - now_l3))
  [[ $five_rem_secs -lt 0 ]] && five_rem_secs=0
  five_rem_pct=$((five_rem_secs * 100 / 18000))
  [[ $five_rem_pct -gt 100 ]] && five_rem_pct=100
else
  five_rem_pct=100
fi

# 7d window = 604800s
if [[ $seven_reset_epoch -gt 0 ]]; then
  seven_rem_secs=$((seven_reset_epoch - now_l3))
  [[ $seven_rem_secs -lt 0 ]] && seven_rem_secs=0
  seven_rem_pct=$((seven_rem_secs * 100 / 604800))
  [[ $seven_rem_pct -gt 100 ]] && seven_rem_pct=100
else
  seven_rem_pct=100
fi

five_rem_bar=$(remaining_bar "$five_rem_pct")
seven_rem_bar=$(remaining_bar "$seven_rem_pct")

five_time=""
[[ $five_reset_epoch -gt 0 ]] && five_time=$(format_remaining "$five_reset_epoch")
seven_time=""
[[ $seven_reset_epoch -gt 0 ]] && seven_time=$(format_remaining "$seven_reset_epoch")
five_time_fmt=$(printf "%5s" "$five_time")
seven_time_fmt=$(printf "%5s" "$seven_time")

line3="  󰄉 ${five_rem_bar} ${five_time_fmt} ${sep} 󰄉 ${seven_rem_bar} ${seven_time_fmt}"

# ── Output ──────────────────────────────────────
echo -e "${line1}"
echo -e "${line2}"
echo -e "${line3}"
