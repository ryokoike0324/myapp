require 'rails_helper'

RSpec.describe '受注者' do

  describe 'アカウント情報更新' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    def extract_confirmation_url(mail)
      body = mail.body.encoded
      body[/http[^"]+/]
    end

    let!(:contractor){ create(:contractor) }

    context 'メールアドレスとパスワードを更新する場合' do
      it '正しい新しいパスワード、現在のパスワードを入力すれば成功すること' do
        log_in_as contractor
        visit root_path
        click_link_or_button 'アカウント'
        # アカウント編集ページに遷移すること
        expect(current_path).to eq edit_contractor_registration_path
        expect(page).to have_content 'アカウント編集'
        # ユーザーのアカウント情報が表示されていること
        expect(page).to have_field 'メールアドレス', with: contractor.email
        # メールアドレスを変更すると認証メールが送信されること
        expect do
          fill_in 'メールアドレス', with: 'example@example.com'
          fill_in '現在のパスワード', with: contractor.password
          fill_in '新しいパスワード', with: 'test1234TEST'
          fill_in 'パスワード（確認用）', with: 'test1234TEST'
          click_link_or_button '更新'
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content '本人確認用メールより確認処理をおこなってください。'
        # ログアウトしていること
        expect(current_path).to eq root_path
        mail = ActionMailer::Base.deliveries.last
        after_signup_url = extract_confirmation_url(mail)
        visit after_signup_url
        # 認証用のメールからリンクを踏むとrootに遷移すること
        expect(current_path).to eq root_path
        # ログインしていること
        expect(page).to have_content 'ログアウト'
        # flashが表示されていること
        expect(page).to have_content 'アカウント登録が完了しました。'
        click_link_or_button 'ログアウト'
        click_link_or_button 'ログイン'
        click_link_or_button '受注者ログイン'
        # 更新された情報でログインできること
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: 'test1234TEST'
        click_link_or_button '受注者ログイン'
        expect(page).to have_content 'ログアウト'
      end

      it '不正な情報を入力すると失敗すること' do
        log_in_as contractor
        visit root_path
        click_link_or_button 'アカウント'
        expect do
          fill_in 'メールアドレス', with: 'example@example.com'
          fill_in '新しいパスワード', with: 'test1234TEST'
          fill_in 'パスワード（確認用）', with: 'test1234TEST'
          fill_in '現在のパスワード', with: 'failTestPass'
          click_link_or_button '更新'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'を入力してください'
        expect(current_path).to eq contractor_registration_path
      end

    end

    context 'パスワードのみ更新する場合' do
      it '正しい新しいパスワードを入力すれば成功し、確認メールは送信されないこと' do
        log_in_as contractor
        visit root_path
        click_link_or_button 'アカウント'
        expect do
          # 登録されてるメールアドレスは入力されているはず
          fill_in '新しいパスワード', with: 'test1234TEST'
          fill_in 'パスワード（確認用）', with: 'test1234TEST'
          fill_in '現在のパスワード', with: contractor.password
          click_link_or_button '更新'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'アカウント情報を変更しました。'
        expect(current_path).to eq root_path
      end
    end

    context 'メールアドレスのみ更新する場合' do
      it '正しいメールアドレスを入力すれば成功し、確認メールが送信されること' do
        log_in_as contractor
        visit root_path
        click_link_or_button 'アカウント'
        expect do
          # 新しいパスワードは入力せずとも登録できるはず
          fill_in 'メールアドレス', with: 'new-test-email@example.com'
          fill_in '現在のパスワード', with: contractor.password
          click_link_or_button '更新'
          expect(page).to have_content '本人確認用メールより確認処理をおこなってください。'
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content '本人確認用メールより確認処理をおこなってください。'
        expect(current_path).to eq root_path
        mail = ActionMailer::Base.deliveries.last
        after_signup_url = extract_confirmation_url(mail)
        visit after_signup_url
        # 認証用のメールからリンクを踏むとrootに遷移すること
        expect(current_path).to eq root_path
        # ログインしていること
        expect(page).to have_content 'ログアウト'
        # flashが表示されていること
        expect(page).to have_content 'アカウント登録が完了しました。'
        # 変更したメールアドレスでログインできること
        click_link_or_button 'ログアウト'
        click_link_or_button 'ログイン'
        click_link_or_button '受注者ログイン'
        fill_in 'メールアドレス', with: 'new-test-email@example.com'
        fill_in 'パスワード', with: contractor.password
        click_link_or_button '受注者ログイン'
        expect(page).to have_content 'ログアウト'
      end
    end
  end
end
