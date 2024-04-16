# First Step
 Web制作初学者と小規模事情者のためのマッチングサービスです。
 実績のない方でも事業者様から仕事を受注でき、実績を積むことができます。
 事業者様は複数の仕事を登録でき、無料でWebサイト制作が依頼できます。

# URL
https://my-rails-app-20cfaca02579.herokuapp.com/
現在製作途中ですが、画面右上の「簡単ログイン」ボタンから、メールアドレスとパスワードを入力せず「ゲストユーザー」としてログインできます。

# 使用技術
・Ruby 3.3.0
・Ruby on Rails 7.1.3
・MySQL 8.3.0
・Heroku
・Docker/Docker-compose
・RSpec
・tailwindcss
・Javascript

# 機能一覧
## 共通
・受注者・発注者登録、認証機能(devise)
・メール配信機能(ActionMailer)
・お問い合わせ機能
・バックグラウンドによる通知機能(ActiveJob)
・ページネーション機能（kaminari）
・検索・絞り込み・並び替え機能(ransack)

## 発注者機能
・お仕事登録機能
・応募者一覧機能
・応募者詳細表示機能
・応募中のお仕事一覧

## 受注者機能
・お気に入り機能
・お仕事への応募機能
・お気に入り・応募したお仕事一覧

# テスト
・RSpec
  ・単体テスト（model）
  ・統合テスト(system)