require 'rails_helper'

RSpec.describe '受注者' do
  describe '新規登録' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    def extract_confirmation_url(mail)
      body = mail.body.encoded
      body[/http[^"]+/]
    end

    let(:contractor){ build(:contractor) }

    context '正しい値を入力したとき' do
      scenario '新規登録が成功し、プロフィール登録ができること' do
        visit root_path
        expect(page).to have_http_status :ok
        click_link_or_button '新規登録'
        click_link_or_button '受注者登録'
        expect do
          fill_in 'メールアドレス', with: contractor.email
          fill_in 'パスワード', with: contractor.password
          fill_in 'パスワード確認', with: contractor.password
          click_link_or_button '受注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content '本人確認用のメールを送信しました。'
        expect(current_path).to eq root_path
        mail = ActionMailer::Base.deliveries.last
        url = extract_confirmation_url(mail)
        visit url
        expect(page).to have_content 'アカウント登録が完了しました。プロフィールを登録して下さい。'
        expect(current_path).to eq edit_contractor_profile_path(contractor)
        expect(page).to have_content 'プロフィール編集'
        fill_in 'お名前', with: ''
      end
    end

    context '不正な値を入力したとき' do
      scenario 'ユーザー登録に失敗すること' do
        visit new_contractor_registration_path
        expect do
          fill_in 'メールアドレス', with: 'hogehoge'
          fill_in 'パスワード', with: '*****'
          fill_in 'パスワード確認', with: nil
          click_link_or_button '受注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'メールアドレスは不正な値です'
        expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(current_path).to eq contractor_registration_path
      end
    end
  end

  describe 'ログイン' do
    let!(:contractor){ create(:contractor) }

    context '正しい値を入力したとき' do
      it 'ログインに成功すること' do
        visit root_path
        click_link_or_button 'ログイン'
        click_link_or_button '受注者ログイン'
        fill_in 'メールアドレス', with: contractor.email
        fill_in 'パスワード', with: contractor.password
        click_link_or_button '受注者ログイン'
        expect(page).to have_content 'ログインしました。'
        expect(page).to have_link 'ログアウト'
        expect(current_path).to eq privacy_path
      end
    end

    context '不正な値を入力したとき' do
      it 'ログインに失敗すること' do
        visit root_path
        click_link_or_button 'ログイン'
        click_link_or_button '受注者ログイン'
        fill_in 'メールアドレス', with: 'hogefoobar@123_456'
        fill_in 'パスワード', with: 1234
        click_link_or_button '受注者ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        expect(current_path).to eq new_contractor_session_path
        expect(page).to have_link 'ログイン'
      end
    end
  end

  describe 'ゲストユーザーのログイン' do

    it '簡単ログインに成功すること' do
      visit root_path
      click_link_or_button '簡単ログイン'
      click_link_or_button '受注者ゲストログイン'
      expect(page).to have_content 'ログインしました。'
      expect(page).to have_link 'ログアウト'
      expect(current_path).to eq root_path
    end

  end

  describe 'ログアウト' do
    let!(:contractor){ create(:contractor) }

    it 'ログインしているユーザーはログアウトできること' do
      login_as contractor
      click_link_or_button 'ログアウト'
      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_link 'ログイン'
      expect(current_path).to eq root_path

    end
  end

  describe 'プロフィール編集' do
    let!(:contractor){ create(:contractor) }

    it 'ログインしている受注者はプロフィールを編集できること' do
      login_as contractor
      click_link_or_button 'プロフィール編集'
      fill_in 'お名前', with: 'testuser'
      attach_file 'プロフィール画像',  Rails.root.join('spec/files/test-avator.png').to_s
      fill_in '自己PR', with: '初めまして太郎です。'
      select '１年以上', from: '勉強期間'
      click_link_or_button '登録'
      expect(page).to have_content 'プロフィール登録が完了しました'
      # expect(current_path).to show_
    end
  end

end
