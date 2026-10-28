# claude-remote-bg

`claude remote-control` をバックグラウンド (nohup) で起動・管理するスクリプトです。

## クイックスタート

GitHub から clone して起動するまでのサンプルです。

```bash
git clone https://github.com/toshi0907/claude-remote-bg.git
cd claude-remote-bg
chmod +x claude-remote.sh

# 作業ディレクトリを作成し、指定して起動 (省略時は $HOME)
mkdir -p "$HOME/projects"
WORK_DIR="$HOME/projects" ./claude-remote.sh start

# 状態確認・ログ表示
./claude-remote.sh status
./claude-remote.sh log
```

※ 事前に Claude Code (`claude` コマンド) をインストールし、PATH を通しておいてください。

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
