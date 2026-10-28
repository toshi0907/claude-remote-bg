#!/usr/bin/env bash
# claude remote-control をバックグラウンド(nohup)で起動・管理するスクリプト
# 使い方: ./claude-remote.sh {start|stop|restart|status|log}
#
# 環境変数で上書き可能:
#   WORK_DIR  claude を起動する作業ディレクトリ (既定: $HOME)
#   STATE_DIR PIDファイルとログの保存先 (既定: $HOME/.claude-remote)

set -euo pipefail

WORK_DIR="${WORK_DIR:-$HOME}"
STATE_DIR="${STATE_DIR:-$HOME/.claude-remote}"
PID_FILE="$STATE_DIR/claude-remote.pid"
LOG_FILE="$STATE_DIR/claude-remote.log"

mkdir -p "$STATE_DIR"

is_running() {
  [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

start() {
  if is_running; then
    echo "既に起動中です (PID: $(cat "$PID_FILE"))"
    return 0
  fi
  if ! command -v claude >/dev/null 2>&1; then
    echo "エラー: claude コマンドが見つかりません。Claude Code をインストールしてPATHを通してください。" >&2
    exit 1
  fi
  cd "$WORK_DIR"
  nohup claude remote-control </dev/null >>"$LOG_FILE" 2>&1 &
  echo $! >"$PID_FILE"
  sleep 2
  if is_running; then
    echo "起動しました (PID: $(cat "$PID_FILE"))"
    echo "ログ: $LOG_FILE"
  else
    echo "起動に失敗しました。ログを確認してください: $LOG_FILE" >&2
    rm -f "$PID_FILE"
    exit 1
  fi
}

stop() {
  if ! is_running; then
    echo "起動していません"
    rm -f "$PID_FILE"
    return 0
  fi
  local pid
  pid="$(cat "$PID_FILE")"
  kill "$pid"
  for _ in $(seq 1 10); do
    kill -0 "$pid" 2>/dev/null || break
    sleep 1
  done
  if kill -0 "$pid" 2>/dev/null; then
    kill -9 "$pid"
  fi
  rm -f "$PID_FILE"
  echo "停止しました"
}

status() {
  if is_running; then
    echo "起動中 (PID: $(cat "$PID_FILE"))"
  else
    echo "停止中"
  fi
}

case "${1:-}" in
  start)   start ;;
  stop)    stop ;;
  restart) stop; start ;;
  status)  status ;;
  log)     tail -n 50 -f "$LOG_FILE" ;;
  *)
    echo "使い方: $0 {start|stop|restart|status|log}" >&2
    exit 1
    ;;
esac
