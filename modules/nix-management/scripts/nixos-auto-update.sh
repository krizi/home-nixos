#!/usr/bin/env bash
set -euo pipefail

exec 2>&1

REPO_DIR="/etc/nixos"
STATE_DIR="/var/lib/nixos-auto-update"
METRICS_FILE="$STATE_DIR/metrics.prom"

mkdir -p "$STATE_DIR"

start_ts="$(date +%s)"

# Defaults für Git-Infos
GIT_BRANCH="unknown"
GIT_LOCAL_HEAD="unknown"
GIT_REMOTE_HEAD="unknown"
GIT_COMMITS_BEHIND="0"

log() {
  echo "[auto-update][$HOSTNAME] $*"
}

write_metrics() {
  local result="$1"    # 1=success, 0=failure, 2=no_change
  local end_ts="$2"
  local duration="$3"

  local success_file="$STATE_DIR/success_total"
  local failure_file="$STATE_DIR/failure_total"

  local success_total="0"
  local failure_total="0"

  [ -f "$success_file" ] && success_total="$(cat "$success_file" || echo 0)"
  [ -f "$failure_file" ] && failure_total="$(cat "$failure_file" || echo 0)"

  case "$result" in
    1) success_total=$((success_total + 1)) ;;
    0) failure_total=$((failure_total + 1)) ;;
    *) ;;
  esac

  echo "$success_total" > "$success_file"
  echo "$failure_total" > "$failure_file"

  cat > "$METRICS_FILE" <<EOF
# HELP nixos_auto_update_last_result Result of last auto-update (1=success, 0=failure, 2=no_change)
# TYPE nixos_auto_update_last_result gauge
nixos_auto_update_last_result{host="${HOSTNAME}"} ${result}

# HELP nixos_auto_update_last_timestamp_seconds Unix timestamp of last auto-update attempt
# TYPE nixos_auto_update_last_timestamp_seconds gauge
nixos_auto_update_last_timestamp_seconds{host="${HOSTNAME}"} ${end_ts}

# HELP nixos_auto_update_last_duration_seconds Duration of last auto-update attempt in seconds
# TYPE nixos_auto_update_last_duration_seconds gauge
nixos_auto_update_last_duration_seconds{host="${HOSTNAME}"} ${duration}

# HELP nixos_auto_update_success_total Total number of successful auto-updates
# TYPE nixos_auto_update_success_total counter
nixos_auto_update_success_total{host="${HOSTNAME}"} ${success_total}

# HELP nixos_auto_update_failure_total Total number of failed auto-updates
# TYPE nixos_auto_update_failure_total counter
nixos_auto_update_failure_total{host="${HOSTNAME}"} ${failure_total}

# HELP nixos_auto_update_git_commits_behind_remote Number of commits local HEAD is behind remote
# TYPE nixos_auto_update_git_commits_behind_remote gauge
nixos_auto_update_git_commits_behind_remote{host="${HOSTNAME}",branch="${GIT_BRANCH}"} ${GIT_COMMITS_BEHIND}

# HELP nixos_auto_update_git_info Info about last evaluated git state (labels: branch, local, remote)
# TYPE nixos_auto_update_git_info gauge
nixos_auto_update_git_info{host="${HOSTNAME}",branch="${GIT_BRANCH}",local="${GIT_LOCAL_HEAD}",remote="${GIT_REMOTE_HEAD}"} 1
EOF
}

if [ ! -d "$REPO_DIR/.git" ]; then
  log "$REPO_DIR ist kein Git-Repo. Abbruch."
  end_ts="$(date +%s)"
  write_metrics 0 "$end_ts" "$((end_ts - start_ts))"
  exit 1
fi

cd "$REPO_DIR"

# Versuche Git-Infos so früh wie möglich zu holen
if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
  GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD || echo unknown)"
fi

if git rev-parse HEAD >/dev/null 2>&1; then
  GIT_LOCAL_HEAD="$(git rev-parse HEAD || echo unknown)"
fi

if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
  log "Kein Upstream-Branch (git @{u}). Abbruch."
  end_ts="$(date +%s)"
  write_metrics 0 "$end_ts" "$((end_ts - start_ts))"
  exit 1
fi

log "Hole Änderungen von Git..."
git fetch --all --prune

GIT_REMOTE_HEAD="$(git rev-parse @{u} || echo unknown)"

# Commits, die lokal hinter remote sind
if [ "$GIT_LOCAL_HEAD" != "unknown" ] && [ "$GIT_REMOTE_HEAD" != "unknown" ]; then
  GIT_COMMITS_BEHIND="$(git rev-list --count "${GIT_LOCAL_HEAD}..${GIT_REMOTE_HEAD}" 2>/dev/null || echo 0)"
fi

LOCAL="$GIT_LOCAL_HEAD"
REMOTE="$GIT_REMOTE_HEAD"

if [ "$LOCAL" = "$REMOTE" ]; then
  log "Keine neuen Commits. Nichts zu tun."
  end_ts="$(date +%s)"
  write_metrics 2 "$end_ts" "$((end_ts - start_ts))"
  exit 0
fi

log "Neue Commits gefunden. Pull + Build (.#$HOSTNAME)..."
git pull --rebase

# Nach dem Pull Local-Head und Branch aktualisieren
GIT_LOCAL_HEAD="$(git rev-parse HEAD || echo unknown)"
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD || echo "$GIT_BRANCH")"
nixos-rebuild build --flake ".#$HOSTNAME"
if nixos-rebuild build --flake ".#$HOSTNAME"; then
  log "Build OK. Switch wird ausgeführt..."
  nixos-rebuild switch --flake ".#$HOSTNAME" --no-write-lock-file
  log "Update erfolgreich abgeschlossen."
  end_ts="$(date +%s)"
  write_metrics 1 "$end_ts" "$((end_ts - start_ts))"
else
  log "Build FEHLGESCHLAGEN. Kein Switch ausgeführt."
  end_ts="$(date +%s)"
  write_metrics 0 "$end_ts" "$((end_ts - start_ts))"
  exit 1
fi
