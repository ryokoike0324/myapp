require 'rails_helper'

RSpec.describe '受注者' do

  describe 'パスワード再設定' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    def extract_confirmation_url(mail)
      body = mail.body.encoded
      body[/http[^"]+/]
    end

    let!(:contractor){ create(:contractor) }

    context '登録されているメールアドレスを入力した場合' do
      it 'パスワード再設定に成功すること' do
        visit new_contractor_session_path
        click_link_or_button 'パスワードを忘れた方'
        fill_in 'メールアドレス', with: contractor.email
        expect do
          click_link_or_button 'パスワード再設定メールを送信'
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
        expect(current_path).to eq new_contractor_session_path
        mail = ActionMailer::Base.deliveries.last
        url = extract_confirmation_url(mail)
        visit url
        expect(current_path).to eq edit_contractor_password_path
        fill_in '新しいパスワード', with: 'newpassword'
        fill_in 'パスワード（確認用）', with: 'newpassword'
        click_link_or_button '登録する'
        expect(current_path).to eq clients_requests_path
        expect(page).to have_content 'パスワードが正しく変更されました。'
        click_link_or_button 'ログアウト'
        # 変更されたパスワードで正しくログインできる
        visit new_contractor_session_path
        fill_in 'メールアドレス', with: contractor.email
        fill_in 'パスワード', with: 'newpassword'
        click_link_or_button '受注者ログイン'
        expect(page).to have_content 'ログアウト'
      end
    end

    context '登録されていないメールアドレスを入力した場合' do
      it 'パスワード再設定に失敗すること' do
        visit new_contractor_session_path
        click_link_or_button 'パスワードを忘れた方'
        fill_in 'メールアドレス', with: 'failure@example.com'
        expect do
          click_link_or_button 'パスワード再設定メールを送信'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'メールアドレスは見つかりませんでした。'
        expect(current_path).to eq contractor_password_path
      end
    end

  end
end
