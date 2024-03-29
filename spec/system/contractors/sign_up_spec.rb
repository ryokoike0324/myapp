require 'rails_helper'

RSpec.describe '受注者' do
  describe '新規登録' do
    let(:contractor){ build(:contractor, :with_profile) }

    before do
      ActionMailer::Base.deliveries.clear
    end

    def extract_confirmation_url(mail)
      body = mail.body.encoded
      body[/http[^"]+/]
    end


    context '正しい値を入力したとき' do

      it '新規登録が成功すること' do
        visit root_path
        expect(page).to have_http_status :ok
        click_link_or_button '新規登録'
        click_link_or_button '受注者新規登録'
        expect do
          fill_in 'メールアドレス', with: contractor.email
          fill_in 'パスワード （6字以上）', with: contractor.password
          fill_in 'パスワード（確認用）', with: contractor.password
          click_link_or_button '受注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content '本人確認用のメールを送信しました。'
        expect(current_path).to eq root_path
        mail = ActionMailer::Base.deliveries.last
        url = extract_confirmation_url(mail)
        visit url
        expect(page).to have_content 'アカウント登録が完了しました。'
        # 登録後ログインしていること
        expect(page).to have_content 'ログアウト'
        current_user = Contractor.find_by(email: contractor.email)
        # プロフィール編集ページに遷移している
        expect(current_path).to eq edit_contractor_profile_path(current_user)
        fill_in 'お名前', with: 'テスト太郎'
        update_image_url = Rails.root.join('spec/files/after_test_avator.png').to_s
        attach_file 'プロフィール画像',  update_image_url
        fill_in '自己PR', with: '初めましてテスト太郎です。よろしくお願いします。'
        fill_in 'ポートフォリオURL', with: 'https://bartell-toy.test/lanita'
        select '１年以上', from: '勉強期間'
        click_link_or_button '登録'
        # プロフィール登録後TOPページに遷移している
        expect(current_path).to eq root_path
      end
    end

    context '不正な値を入力したとき' do
      scenario 'ユーザー登録に失敗すること' do
        visit new_contractor_registration_path
        expect do
          fill_in 'メールアドレス', with: 'hogehoge'
          fill_in 'パスワード （6字以上）', with: '*****'
          fill_in 'パスワード（確認用）', with: nil
          click_link_or_button '受注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'メールアドレスの形式が間違っています'
        expect(page).to have_content '入力されたパスワードと一致しません。'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(current_path).to eq contractor_registration_path
      end
    end

    describe 'アカウント確認メールの再送信' do
      context '登録したメールアドレスの場合' do
        it 'メールが再送信され、アカウント登録が成功すること' do
          visit root_path
          expect(page).to have_http_status :ok
          click_link_or_button '新規登録'
          click_link_or_button '受注者新規登録'
          fill_in 'メールアドレス', with: contractor.email
          fill_in 'パスワード （6字以上）', with: contractor.password
          fill_in 'パスワード（確認用）', with: contractor.password
          click_link_or_button '受注者アカウント登録'
          visit new_contractor_registration_path
          click_link_or_button 'アカウント確認メールが届きませんでしたか？'
          fill_in 'メールアドレス', with: contractor.email
          expect do
            click_link_or_button 'アカウント確認メール再送'
          end.to change { ActionMailer::Base.deliveries.size }.by(1)
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
          click_link_or_button '受注者新規登録'
          click_link_or_button 'アカウント確認メールが届きませんでしたか？'
          fill_in 'メールアドレス', with: contractor.email
          expect do
            click_link_or_button 'アカウント確認メール再送'
          end.to change { ActionMailer::Base.deliveries.size }.by(0)
          expect(page).to have_content 'メールアドレスは見つかりませんでした。'
        end
      end
    end
  end
end
