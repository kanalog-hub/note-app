# Phase2 テスト環境整備

## ステップ1: Vitestをフロントエンドに導入

```bash
docker-compose exec web npm install -D vitest @vitest/ui @testing-library/react @testing-library/jest-dom jsdom
```

## ステップ2: Vitest設定ファイル作成
**web/vitest.config.ts**  を作成します：
```ts
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./vitest.setup.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'dist/',
        '.next/',
      ],
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
```

## ステップ3: Vitest セットアップファイル作成

cat > web/vitest.setup.ts << 'EOF'
import '@testing-library/jest-dom'
EOF


## ステップ4: package.json にテストスクリプト追加

```bash
docker-compose exec web npm install -D @vitest/coverage-v8
```
**web/package.json** の scripts セクションを修正します：
```json
"scripts": {
  "dev": "next dev",
  "build": "next build",
  "start": "next start",
  "lint": "next lint",
  "test": "vitest",
  "test:ui": "vitest --ui",
  "test:coverage": "vitest --coverage"
}
```

## ステップ5: サンプルテスト作成
web/__tests__/example.test.ts を作成します：

```ts
import { describe, it, expect } from 'vitest'

describe('Example Test', () => {
  it('should pass', () => {
    expect(1 + 1).toBe(2)
  })

  it('string concatenation', () => {
    expect('Hello' + ' ' + 'World').toBe('Hello World')
  })
})
```

## ステップ6: テスト実行

```bash
docker compose exec web npm  test
```

## ステップ7: テストカバレッジ

```bash
docker compose exec web npm  test:coverage
```

# バックエンド: PHP Unit セットアップ

## ステップ8: PHP UNnit 確認

LaravelにはPHPUnitが既に含まれているので、確認だけします。
```bash
docker compose exec api php artisan test --list
```

## ステップ9: PHP Unit 設定確認
api/phpunit.xml を確認します。

## ステップ10: PHP Unit テスト作成
**api/tests/Unit/ExampleTest.php** を作成します。
```php

<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{
    public function test_addition(): void
    {
        $this->assertEquals(2, 1 + 1);
    }

    public function test_string_concatenation(): void
    {
        $result = 'Hello' . ' ' . 'World';
        $this->assertEquals('Hello World', $result);
    }
}
```

## ステップ11: バックエンドテスト実行

```bash
docker compose exec api php artisan test

```

## ステップ12: バックエンドテストカバレッジ

```bash
docker compose exec api php artisan test:coverage
```

## ステップ13: コミット

```bash
git add .
git commit -m "feat: setup vitest and phpunit with sample tests"
git push
```

## ステップ14: プルリクエスト作成

```bash
git checkout -b feature/php-unit-tests



Phase 2 完了！
確認項目：

✅ docker-compose exec web npm test → パス
✅ docker-compose exec api php artisan test → パス
✅ GitHub にコミット

