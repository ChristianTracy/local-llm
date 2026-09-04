#!/usr/bin/env bash
set -euo pipefail

MODELS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER="$HOME/workspace/llama.cpp/build/bin/llama-server"
PIDFILE="$MODELS_DIR/router.pid"
LOGFILE="$MODELS_DIR/router.log"

cd "$MODELS_DIR"

SERVER_ARGS=(
  --models-preset "$MODELS_DIR/models.ini"
  --models-max 1
  --host 0.0.0.0
  --port 8080
)

usage() {
  cat <<EOF
Usage: $0 [options]

  -d, --detach   Run the router in the background (detached)
  -s, --stop     Stop the detached router service
  -h, --help     Show this help

Without options, runs the router in the foreground.
EOF
}

stop_router() {
  if [[ ! -f "$PIDFILE" ]]; then
    echo "No pidfile found at $PIDFILE; router is not running (detached)." >&2
    return 1
  fi
  local pid
  pid="$(cat "$PIDFILE")"
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid"
    for _ in $(seq 1 50); do
      kill -0 "$pid" 2>/dev/null || break
      sleep 0.1
    done
    if kill -0 "$pid" 2>/dev/null; then
      echo "Router (pid $pid) did not stop gracefully; sending SIGKILL." >&2
      kill -9 "$pid"
    else
      echo "Router stopped (pid $pid)."
    fi
  else
    echo "Router (pid $pid) is not running; stale pidfile removed." >&2
  fi
  rm -f "$PIDFILE"
}

case "${1:-}" in
  -d|--detach)
    if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
      echo "Router is already running (pid $(cat "$PIDFILE"))." >&2
      exit 1
    fi
    rm -f "$PIDFILE" "$LOGFILE"
    nohup "$SERVER" "${SERVER_ARGS[@]}" >"$LOGFILE" 2>&1 &
    echo $! > "$PIDFILE"
    echo "Router started in background (pid $(cat "$PIDFILE")). Log: $LOGFILE"
    ;;
  -s|--stop)
    stop_router
    ;;
  -h|--help)
    usage
    ;;
  "")
    exec "$SERVER" "${SERVER_ARGS[@]}"
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage >&2
    exit 1
    ;;
esac