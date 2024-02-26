require 'rails_helper'

RSpec.describe '発注者', type: :system do
  describe '新規登録' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    def extract_confirmation_url(mail)
      body = mail.body.encoded
      body[/http[^"]+/]
    end

    let(:client){ build(:client) }

    context '正しい値を入力したとき' do
      scenario '新規登録が成功すること' do
        visit root_path
        expect(page).to have_http_status :ok
        click_link_or_button '新規登録'
        click_link_or_button '発注者登録'
        expect do
          fill_in 'Email', with: client.email
          fill_in 'Password', with: client.password
          fill_in 'Password confirmation', with: client.password
          click_link_or_button '発注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content '本人確認用のメールを送信しました。'
        expect(current_path).to eq root_path
        mail = ActionMailer::Base.deliveries.last
        url = extract_confirmation_url(mail)
        visit url
        expect(page).to have_content 'メールアドレスが確認できました。'
        # expect(current_path).to eq edit_client_registration_path(client)
      end
    end

    context '不正な値を入力したとき' do
      scenario 'ユーザー登録に失敗すること' do
        visit new_client_registration_path
        expect do
          fill_in 'Email', with: 'hogehoge'
          fill_in 'Password', with: '*****'
          fill_in 'Password confirmation', with: nil
          click_link_or_button '発注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'Emailは不正な値です'
        expect(page).to have_content 'Password confirmationとPasswordの入力が一致しません'
        expect(page).to have_content 'Passwordは6文字以上で入力してください'
        expect(current_path).to eq client_registration_path
      end
    end
  end

  describe 'ログイン' do
    let!(:client){ create(:client) }

    context '正しい値を入力したとき' do
      it 'ログインに成功した後、ログアウトできること' do
        visit root_path
        click_link_or_button 'ログイン'
        click_link_or_button '発注者ログイン'
        fill_in 'Email', with: client.email
        fill_in 'Password', with: client.password
        click_link_or_button '発注者ログイン'
        expect(page).to have_content 'ログインしました。'
        expect(page).to have_link 'ログアウト'
        expect(current_path).to eq terms_path
      end
    end

    context '不正な値を入力したとき' do
      it 'ログインに失敗すること' do
        visit root_path
        click_link_or_button 'ログイン'
        click_link_or_button '発注者ログイン'
        fill_in 'Email', with: 'hogefoobar@123_456'
        fill_in 'Password', with: 1234
        click_link_or_button '発注者ログイン'
        expect(page).to have_content 'Emailまたはパスワードが違います。'
        expect(current_path).to eq new_client_session_path
        expect(page).to have_link 'ログイン'
      end
    end
  end

  describe 'ログアウト' do
    let!(:client){ create(:client) }

    it 'ログインしているユーザーはログアウトできること' do
      login_as client
      click_link_or_button 'ログアウト'
      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_link 'ログイン'
      expect(current_path).to eq root_path

    end
  end

end
