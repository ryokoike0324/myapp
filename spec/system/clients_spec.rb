require 'rails_helper'

RSpec.describe '発注者' do
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
          fill_in 'メールアドレス', with: client.email
          fill_in 'パスワード', with: client.password
          fill_in 'パスワード確認', with: client.password
          click_link_or_button '発注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content '本人確認用のメールを送信しました。'
        expect(current_path).to eq root_path
        mail = ActionMailer::Base.deliveries.last
        url = extract_confirmation_url(mail)
        visit url
        expect(page).to have_content 'メールアドレスが確認できました。'
        # 登録後ログインしていること
        expect(page).to have_content 'ログアウト'
        # プロフィール編集ページに遷移している
        expect(page).to have_content 'プロフィール'
        current_user = Client.find_by(email: client.email)
        expect(current_path).to eq edit_client_profile_path(current_user)
      end
    end

    context '不正な値を入力したとき' do
      scenario 'ユーザー登録に失敗すること' do
        visit new_client_registration_path
        expect do
          fill_in 'メールアドレス', with: 'hogehoge'
          fill_in 'パスワード', with: '*****'
          fill_in 'パスワード確認', with: nil
          click_link_or_button '発注者アカウント登録'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'メールアドレスは不正な値です'
        expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(current_path).to eq client_registration_path
      end
    end
  end

  describe 'ログイン' do
    let!(:client){ create(:client) }

    context '正しい値を入力したとき' do
      it 'ログインに成功すること' do
        visit root_path
        click_link_or_button 'ログイン'
        click_link_or_button '発注者ログイン'
        fill_in 'メールアドレス', with: client.email
        fill_in 'パスワード', with: client.password
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
        fill_in 'メールアドレス', with: 'hogefoobar@123_456'
        fill_in 'パスワード', with: 1234
        click_link_or_button '発注者ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        expect(current_path).to eq new_client_session_path
        expect(page).to have_link 'ログイン'
      end
    end
  end

  describe 'ゲストユーザーのログイン' do

    it '簡単ログインに成功すること' do
      visit root_path
      click_link_or_button '簡単ログイン'
      click_link_or_button '発注者ゲストログイン'
      expect(page).to have_content 'ログインしました。'
      expect(page).to have_link 'ログアウト'
      expect(current_path).to eq root_path
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

  describe 'プロフィール' do
    let!(:client){ create(:client, :with_profile) }

    it 'ログインしている発注者は自身のプロフィールを表示でき、プロフィールを編集できること' do
      login_as client
      click_link_or_button 'プロフィール'
      # リンクからプロフィールページに遷移すること
      expect(current_path).to eq client_profile_path(client)
      # すでに登録している情報が表示されていること
      expect(page).to have_content client.name
      expect(page).to have_content client.industry
      expect(page).to have_content client.our_business
      click_link_or_button 'プロフィール編集'
      # プロフィール編集ページに遷移できること
      expect(current_path).to eq edit_client_profile_path(client)
      fill_in '店名・会社名', with: '東京ストリート塩ラーメン'
      fill_in '事業内容', with: '池袋で、美味しい塩ラーメンの店をやっております。'
      select '飲食', from: '業種'
      click_link_or_button '登録'
      # 編集後プロフィールページに正しく遷移すること
      expect(page).to have_content 'プロフィール登録が完了しました'
      expect(current_path).to eq client_profile_path(client)
      # プロフィールページに編集内容が反映されていること
      expect(page).to have_content '東京ストリート塩ラーメン'
      expect(page).to have_content '池袋で、美味しい塩ラーメンの店をやっております。'
      expect(page).to have_content '飲食'
    end
  end

  describe 'アカウント情報更新' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    def extract_confirmation_url(mail)
      body = mail.body.encoded
      body[/http[^"]+/]
    end

    let!(:client){ create(:client) }

    context 'メールアドレスとパスワードを更新する場合' do
      it '正しい新しいパスワード、現在のパスワードを入力すれば成功すること' do
        login_as client
        visit root_path
        click_link_or_button 'アカウント'
        # アカウント編集ページに遷移すること
        expect(current_path).to eq edit_client_registration_path(client)
        expect(page).to have_content 'アカウント編集'
        # ユーザーのアカウント情報が表示されていること
        expect(page).to have_field 'メールアドレス', with: client.email
        # メールアドレスを変更すると認証メールが送信されること
        expect do
          fill_in 'メールアドレス', with: 'example@example.com'
          fill_in '新しいパスワード', with: 'test1234TEST'
          fill_in 'パスワード確認', with: 'test1234TEST'
          fill_in '現在のパスワード', with: client.password
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
        expect(page).to have_content 'メールアドレスが確認できました'
      end

      it '不正な情報を入力すると失敗すること' do
        login_as client
        visit root_path
        click_link_or_button 'アカウント'
        expect do
          fill_in 'メールアドレス', with: 'example@example.com'
          fill_in '新しいパスワード', with: 'test1234TEST'
          fill_in 'パスワード確認', with: 'test1234TEST'
          fill_in '現在のパスワード', with: 'failTestPass'
          click_link_or_button '更新'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'を入力してください'
        expect(current_path).to eq client_registration_path
      end

    end

    context 'パスワードのみ更新する場合' do
      it '正しい新しいパスワードを入力すれば成功し、確認メールは送信されないこと' do
        login_as client
        visit root_path
        click_link_or_button 'アカウント'
        expect do
          # 登録されてるメールアドレスは入力されているはず
          fill_in '新しいパスワード', with: 'test1234TEST'
          fill_in 'パスワード確認', with: 'test1234TEST'
          fill_in '現在のパスワード', with: client.password
          click_link_or_button '更新'
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
        expect(page).to have_content 'アカウント情報を変更しました。'
        expect(current_path).to eq root_path
      end
    end

    context 'メールアドレスのみ更新する場合' do
      it '正しいメールアドレスを入力すれば成功し、確認メールが送信されること' do
        login_as client
        visit root_path
        click_link_or_button 'アカウント'
        expect do
          # 新しいパスワードは入力せずとも登録できるはず
          fill_in 'メールアドレス', with: 'new-test-email@example.com'
          fill_in '現在のパスワード', with: client.password
          click_link_or_button '更新'
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
        expect(page).to have_content 'メールアドレスが確認できました'
      end
    end
  end

  describe '退会' do

    let!(:client){ create(:client) }

    it 'ログインしているユーザーは退会できること', :js  do
      login_as client
      visit root_path
      click_link_or_button 'アカウント'
      click_link_or_button '退会する'
      expect do
        expect(page.accept_confirm).to eq 'アカウント情報が削除されます。本当に退会しますか？'
        expect(page).to have_content 'アカウントを削除しました'
      end.to change(Client, :count).by(-1)
    end
  end

end
