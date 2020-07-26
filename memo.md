# Rails + Vue.js + Ajax CRUD サンプル

## 導入手順

1. プロジェクト作成

```ruby
mkdir your_app_name
cd your_app_name
rails new . --webpack=vue --skip-turbolinks --skip-action-mailer --skip-action-mailbox --skip-active-storage --skip-test
```

2. DB 設定

- gemfile 変更

```ruby:Gemfile
# gem 'sqlite3', '~> 1.4'
gem 'mysql2'
```

- データベース設定の変更

```yml:database.yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: password # docker-compose.ymlのMYSQL_ROOT_PASSWORD
  host: db # docker-compose.ymlのservice名

development:
  <<: *default
  database: dev_mysql

test:
  <<: *default
  database: test_mysql

production:
  <<: *default
  database: prod_mysql
```

3. webpacker の設定

- `check_yarn_integrity: false`にする

```yml:webpacker.yml
development:
  <<: *default
  compile: true

  # Verifies that correct packages and versions are installed by inspecting package.json, yarn.lock, and node_modules
  check_yarn_integrity: false
```

4. docker 導入

- ファイルを作るかコピーする
  - Dockerfile と docker-compose.yml
- `docker-compose build`
- `docker-compose up`

5. webpack & vue 　インストール(`rails new`のときにオプション指定をしていない人、既存のプロジェクトに導入する人)

- webpacker の gem をインストールして、vue を入れる

## ActiveRecord::Base.connection.execute とは？

[Qiita](https://qiita.com/katsuyuki/items/42b3c69bcd76c44ad64a)

##
