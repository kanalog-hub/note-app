モダンコーディングスキル学習ポートフォリオ
概要

このポートフォリオは、Next.jsとLaravelを使用して、モダンなコーディングスキル、テスト、CI/CDを学習するためのプロジェクトです。最終的には簡易ブログ/メモアプリを構築します。

Next.js: フロントエンド
Laravel: バックエンド（API）

## プロジェクト構成

```
note-app/
├── api/                    # Laravelのバックエンド
│   ├── app/
│   ├── config/
│   ├── database/
│   ├── routes/
│   ├── tests/
│   ├── composer.json
│   ├── .env
│   └── Dockerfile
├── web/                    # Next.jsのフロントエンド
│   ├── app/
│   ├── public/
│   ├── package.json
│   ├── next.config.js
│   ├── .gitignore
│   └── Dockerfile
├── .github/                # GitHub Actionsの設定
│   └── workflows/
├── docker-compose.yml      # Docker Compose設定
├── .env.example            # 環境変数サンプル
├── .gitignore              # Git ignore設定
├── setup.sh                # セットアップスクリプト
├── SETUP_GUIDE.md          # 詳細なセットアップガイド
└── README.md               # このファイル
```

## 必要なツール

- **Docker & Docker Compose**: コンテナ化された開発環境
- **Git**: バージョン管理
- **ターミナル/コマンドプロンプト**: コマンド実行用

## クイックスタート

### 1. リポジトリをクローン

```bash
git clone <your-repository-url>
cd note-app
```

### 2. Docker環境の構築と起動

すべてのサービスを一度に起動します。

```bash
docker compose up -d
```

このコマンドで以下のサービスがバックグラウンドで自動的に起動します：

- **Next.js フロントエンド**: http://localhost:3000
- **Laravel バックエンド API**: http://localhost:8000
- **MySQL データベース**: localhost:3306
- **Redis キャッシュ**: localhost:6379

### 3. ブラウザでアクセス

- フロントエンド: http://localhost:3000
- バックエンド: http://localhost:8000

## 詳細な設定

### 環境変数

Laravelの環境設定は以下のファイルで管理されています：

```bash
api/.env
```

デフォルト設定：
```
DB_HOST=db
DB_PORT=3306
DB_DATABASE=note_app_db
DB_USERNAME=note_app_user
DB_PASSWORD=password
```

### よく使用するコマンド

#### Docker管理

```bash
# すべてのコンテナを起動
docker compose up -d

# すべてのコンテナを停止
docker compose down

# ログをリアルタイム表示
docker compose logs -f

# 特定サービスのログ表示
docker compose logs -f api
docker compose logs -f web
docker compose logs -f db

# コンテナのステータス確認
docker compose ps
```

#### Laravelコマンド

```bash
# マイグレーション実行
docker compose exec api php artisan migrate

# マイグレーションリセット
docker compose exec api php artisan migrate:reset

# シーダー実行
docker compose exec api php artisan db:seed

# ルート一覧確認
docker compose exec api php artisan route:list

# Tinker（対話的シェル）
docker compose exec api php artisan tinker

# テスト実行
docker compose exec api php artisan test
```

#### Next.jsコマンド

```bash
# 依存関係インストール
docker compose exec web npm install

# 開発サーバー起動（既に起動中）
docker compose exec web npm run dev

# ビルド
docker compose exec web npm run build

# 本番実行
docker compose exec web npm start

# リント
docker compose exec web npm run lint

# テスト実行
docker compose exec web npm test
```

#### MySQL コマンド

```bash
# MySQLコンテナに接続
docker compose exec db mysql -u root -proot

# データベース確認
docker compose exec db mysql -u root -proot -e "SHOW DATABASES;"

# テーブル確認
docker compose exec db mysql -u root -proot -e "USE note_app_db; SHOW TABLES;"
```

## トラブルシューティング

### ポート競合エラー

3000番、8000番、3306番ポートが既に使用されている場合は、`docker-compose.yml` のポート設定を変更してください。

```bash
# ポート使用状況確認（macOS/Linux）
lsof -i :3000
lsof -i :8000
lsof -i :3306
```

### Docker デーモンが起動していない

```bash
# Docker Desktop を起動してください
# macOS: Applications > Docker.app から起動
```

### データベース接続エラー

```bash
# MySQLコンテナの状態確認
docker compose ps

# ログを確認
docker compose logs db

# データベースの再起動
docker compose restart db
```

### Next.jsのキャッシュ問題

```bash
# node_modules と .next をクリア
docker compose exec web rm -rf node_modules .next

# 再インストール
docker compose exec web npm install
```

### Laravelのキャッシュ問題

```bash
# キャッシュクリア
docker compose exec api php artisan cache:clear

# ビューキャッシュクリア
docker compose exec api php artisan view:clear

# 設定キャッシュクリア
docker compose exec api php artisan config:clear
```

## 開発フロー

### 1. ブランチ作成・機能実装

```bash
git checkout -b feature/new-feature
# 機能実装...
```

### 2. テスト追加・実行

```bash
# Laravelテスト
docker compose exec api php artisan test

# Next.jsテスト
docker compose exec web npm test
```

### 3. コミット・プッシュ

```bash
git add .
git commit -m "feat: 新機能を追加"
git push origin feature/new-feature
```

### 4. プルリクエスト作成

GitHub でプルリクエストを作成します。

## プロジェクト進行計画

段階的に進めるプランは以下の通りです：

- **Phase 1**: ✅ 環境構築、Next.jsとLaravelのセットアップ
- **Phase 2**: テスト環境整備（Jest, React Testing Library, PHPUnit）
- **Phase 3**: CI/CD構築（GitHub Actions）
- **Phase 4**: モダン Next.js コーディング（Server Components、API Routes）
- **Phase 5**: Laravel 復習（認証、ビジネスロジック）

詳細なセットアップガイドは `SETUP_GUIDE.md` を参照してください。

## サポート

問題が発生した場合：
1. `SETUP_GUIDE.md` のトラブルシューティングセクションを確認
2. ログを確認：`docker compose logs -f`
3. イメージを再ビルド：`docker compose build --no-cache`
4. コンテナを完全リセット：`docker compose down && docker compose up -d`