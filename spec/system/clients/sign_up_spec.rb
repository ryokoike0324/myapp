require 'rails_helper'

RSpec.describe '発注者' do
  describe '新規登録' do
    let(:client){ build(:client) }

    before do
      ActionMailer::Base.deliveries.clear
    end

    def extract_confirmation_url(mail)
      body = mail.body.encoded
      body[/http[^"]+/]
    end


    context '正しい値を入力したとき' do
      let(:request){ build(:request) }

      it '新規登録が成功すること' do
        visit root_path
        expect(page).to have_http_status :ok
        click_link_or_button '新規登録'
        click_link_or_button '発注者新規登録'
        expect do
          fill_in 'メールアドレス', with: client.email
          fill_in 'パスワード （6字以上）', with: client.password
          fill_in 'パスワード（確認用）', with: client.password
          click_link_or_button '発注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content '本人確認用のメールを送信しました。'
        expect(current_path).to eq root_path
        mail = ActionMailer::Base.deliveries.last
        url = extract_confirmation_url(mail)
        visit url
        expect(page).to have_content 'アカウント登録が完了しました。'
        # 登録後ログインしていること
        expect(page).to have_content 'ログアウト'
        current_user = Client.find_by(email: client.email)
        # お仕事登録ページに遷移している
        expect(current_path).to eq new_request_path(current_user)
        expect do
          fill_in 'お仕事タイトル', with: request.title
          fill_in '依頼内容', with: request.description
          fill_in '募集締切', with: request.deadline
          fill_in '納期', with: request.delivery_date
          click_link_or_button('登録')
        end.to change(Request, :count).by(1)
        # プロフィール編集ページに遷移している
        expect(current_path).to eq edit_client_profile_path
        fill_in '店名・会社名', with: '東京ストリート塩ラーメン'
        fill_in '事業内容', with: '池袋で、美味しい塩ラーメンの店をやっております。'
        select '飲食', from: '業種'
        click_link_or_button '登録'
        expect(current_path).to eq root_path
      end
    end

    context '不正な値を入力したとき' do
      scenario 'ユーザー登録に失敗すること' do
        visit new_client_registration_path
        expect do
          fill_in 'メールアドレス', with: 'hogehoge'
          fill_in 'パスワード （6字以上）', with: '*****'
          fill_in 'パスワード（確認用）', with: nil
          click_link_or_button '発注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'メールアドレスは不正な値です'
        expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(current_path).to eq client_registration_path
      end
    end

    describe 'アカウント確認メールの再送信' do
      context '登録したメールアドレスの場合' do
        it 'メールが再送信され、アカウント登録が成功すること' do
          visit root_path
          expect(page).to have_http_status :ok
          click_link_or_button '新規登録'
          click_link_or_button '発注者新規登録'
          fill_in 'メールアドレス', with: client.email
          fill_in 'パスワード （6字以上）', with: client.password
          fill_in 'パスワード（確認用）', with: client.password
          click_link_or_button '発注者アカウント登録'
          visit new_client_registration_path
          click_link_or_button 'アカウント確認メールが届きませんでしたか？'
          fill_in 'メールアドレス', with: client.email
          expect {
            click_link_or_button 'アカウント確認メール再送'
          }.to change { ActionMailer::Base.deliveries.size }.by(1)
          mail = ActionMailer::Base.deliveries.last
          url = extract_confirmation_url(mail)
          visit url
          expect(page).to have_content 'アカウント登録が完了しました。'
        end
      end

      context '登録していないメールアドレスの場合' do
        it 'メールが再送信されないこと' do
          visit root_path
          expect(page).to have_http_status :ok
          click_link_or_button '新規登録'
          click_link_or_button '発注者新規登録'
          click_link_or_button 'アカウント確認メールが届きませんでしたか？'
          fill_in 'メールアドレス', with: client.email
          expect {
            click_link_or_button 'アカウント確認メール再送'
          }.to change { ActionMailer::Base.deliveries.size }.by(0)
          expect(page).to have_content 'メールアドレスは見つかりませんでした。'
        end
      end
    end
  end
end
