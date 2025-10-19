# 環境構築ガイド

このドキュメントは、学習用のnote-appプロジェクトの開発環境を構築するための手順を説明しています。

## 必要な前提条件

- **Docker & Docker Compose**: コンテナ化された開発環境
- **Git**: バージョン管理
- **ターミナル/コマンドプロンプト**: コマンド実行用

## クイックスタート

### 1. リポジトリをクローン

```bash
git clone <your-repository-url>
cd note-app
```

### 2. 自動セットアップスクリプトを実行

```bash
bash setup.sh
```

このスクリプトで以下が自動的に行われます：
- Docker インストール確認
- Laravel プロジェクト作成
- Next.js プロジェクト作成
- Docker コンテナ構築・起動
- データベースマイグレーション

### 3. ブラウザでアクセス

- **フロントエンド**: http://localhost:3000
- **バックエンド**: http://localhost:8000
- **データベース**: localhost:3306

## 手動セットアップ（詳細版）

セットアップスクリプトが機能しない場合は、以下の手順で手動構築してください。

### ステップ1: 基本ディレクトリ構造の確認

```bash
# 必要なディレクトリが存在することを確認
ls -la api/
ls -la web/
```

### ステップ2: Laravelプロジェクトの作成

```bash
# Docker を使用して Laravel プロジェクトを作成
docker run --rm \
  -v $(pwd)/api:/app \
  composer:latest composer create-project --prefer-dist laravel/laravel . --no-scripts
```

### ステップ3: Next.jsプロジェクトの作成

```bash
# Next.js プロジェクトを作成
cd web
npx create-next-app@latest --typescript --tailwind --eslint --app --import-alias --yes .
cd ..
```

### ステップ4: 環境設定ファイルの作成

```bash
# .env ファイルを .env.example からコピー
cp .env.example api/.env
cp .env.example .env
```

### ステップ5: Docker コンテナの構築・起動

```bash
# イメージをビルド
docker-compose build

# コンテナを起動
docker-compose up -d

# ログを確認
docker-compose logs -f
```

### ステップ6: Laravel の初期化

```bash
# マイグレーションを実行
docker-compose exec api php artisan migrate

# 完了確認
docker-compose exec api php artisan tinker
```

## よく使用するコマンド

### Docker コンテナ管理

```bash
# すべてのコンテナ起動
docker-compose up -d

# すべてのコンテナ停止
docker-compose down

# ログ表示（リアルタイム）
docker-compose logs -f

# 特定のサービスのログ表示
docker-compose logs -f api
docker-compose logs -f web

# コンテナ内でコマンド実行
docker-compose exec <service-name> <command>
```

### Laravel コマンド

```bash
# マイグレーション実行
docker-compose exec api php artisan migrate

# シーダー実行
docker-compose exec api php artisan db:seed

# キャッシュクリア
docker-compose exec api php artisan cache:clear

# ルート確認
docker-compose exec api php artisan route:list

# Tinker（対話的シェル）
docker-compose exec api php artisan tinker
```

### Node.js/npm コマンド

```bash
# 依存関係インストール
docker-compose exec web npm install

# 開発サーバー起動
docker-compose exec web npm run dev

# ビルド実行
docker-compose exec web npm run build

# テスト実行
docker-compose exec web npm test

# リント実行
docker-compose exec web npm run lint
```

## トラブルシューティング

### ポート競合エラー

3000番、8000番、3306番ポートが既に使用されている場合：

```bash
# 既存のプロセスを確認・停止
lsof -i :3000
lsof -i :8000
lsof -i :3306

# または docker-compose.yml のポート設定を変更
```

### Docker デーモンが起動していない

```bash
# Docker Desktop を起動してください
# macOS: Applications > Docker.app
```

### データベース接続エラー

```bash
# MySQL コンテナのヘルスチェック確認
docker-compose ps

# ログを確認
docker-compose logs db

# 再起動
docker-compose restart db
```

### Next.js キャッシュ問題

```bash
# node_modules と .next をクリア
docker-compose exec web rm -rf node_modules .next

# 再インストール
docker-compose exec web npm install
docker-compose exec web npm run dev
```

## プロジェクト構造

```
note-app/
├── api/                          # Laravel バックエンド
│   ├── app/
│   ├── config/
│   ├── database/
│   ├── routes/
│   ├── tests/
│   ├── composer.json
│   └── Dockerfile
├── web/                          # Next.js フロントエンド
│   ├── app/
│   ├── src/
│   ├── package.json
│   └── Dockerfile
├── .github/                      # GitHub Actions
│   └── workflows/
├── docker-compose.yml            # Docker Compose 設定
├── .env.example                  # 環境変数サンプル
├── .gitignore                    # Git ignore ルール
├── setup.sh                      # セットアップスクリプト
└── README.md                     # プロジェクト説明
```

## 次のステップ

環境構築が完了したら、以下のフェーズに進みます：

- **Phase 2**: テスト環境整備（Jest, PHPUnit）
- **Phase 3**: CI/CD 構築（GitHub Actions）
- **Phase 4**: モダン Next.js コーディング
- **Phase 5**: Laravel 復習

詳細はREADME.mdを参照してください。

## サポート

問題が発生した場合：
1. このガイドのトラブルシューティングセクションを確認
2. ログを確認：`docker-compose logs`
3. Docker イメージを再ビルド：`docker-compose build --no-cache`
