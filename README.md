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

# 初回のみ: 作業ディレクトリを trust する (詳細は「フォルダの trust」を参照)
(cd "$HOME/projects" && claude)   # 信頼確認ダイアログで「Yes」を選び、/exit で終了

WORK_DIR="$HOME/projects" ./claude-remote.sh start

# 状態確認・ログ表示
./claude-remote.sh status
./claude-remote.sh log
```

※ 事前に Claude Code (`claude` コマンド) をインストールし、PATH を通しておいてください。

## フォルダの trust (初回のみ)

Claude Code は、初めて起動するディレクトリで「このフォルダのファイルを信頼するか」を確認するダイアログを表示します。
本スクリプトは `nohup` でバックグラウンド起動するためダイアログに応答できず、trust されていないディレクトリでは `claude remote-control` が起動に失敗します。
そのため、**`WORK_DIR` に指定するディレクトリは、事前に一度対話モードで trust しておいてください。**

```bash
cd "$HOME/projects"   # WORK_DIR に指定するディレクトリ
claude                # 信頼確認ダイアログで「Yes, I trust this folder」を選択
# Claude Code が起動したら /exit (または Ctrl+C 2回) で終了
```

trust の状態はディレクトリごとに `~/.claude.json` の `projects["<ディレクトリの絶対パス>"].hasTrustDialogAccepted` に保存されます。
一度 trust すれば次回以降は不要です。`WORK_DIR` を別のディレクトリに変更した場合は、そのディレクトリでも同じ手順を行ってください。

trust されているかは次のコマンドで確認できます (`jq` が必要です)。

```bash
jq --arg d "$HOME/projects" '.projects[$d].hasTrustDialogAccepted' ~/.claude.json
# true なら trust 済み
```

起動に失敗した場合は `./claude-remote.sh log` でログを確認し、trust に関するエラーが出ていないか確認してください。

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
