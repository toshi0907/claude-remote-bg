# claude-remote-bg

`claude remote-control` をバックグラウンド (nohup) で起動・管理するスクリプトです。

## 使い方

```bash
./claude-remote.sh start    # 起動
./claude-remote.sh stop     # 停止
./claude-remote.sh restart  # 再起動
./claude-remote.sh status   # 状態確認
./claude-remote.sh log      # ログ表示 (tail -f)
```

## 環境変数

| 変数 | 説明 | 既定値 |
| --- | --- | --- |
| `WORK_DIR` | claude を起動する作業ディレクトリ | `$HOME` |
| `STATE_DIR` | PID ファイルとログの保存先 | `$HOME/.claude-remote` |
