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
        after_signup_url = extract_confirmation_url(mail)
        new_contractor = Contractor.last
        visit after_signup_url
        expect(current_path).to eq edit_contractor_profile_path(new_contractor)
        expect(page).to have_content 'アカウント登録が完了しました。プロフィールを登録して下さい。'
        # 登録後ログインしていること
        expect(page).to have_content 'ログアウト'
        # プロフィール編集ページに遷移している
        expect(page).to have_content 'プロフィール編集'
        current_user = Contractor.find_by(email: contractor.email)
        expect(current_path).to eq edit_contractor_profile_path(current_user)
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
        expect(page).to have_content 'メールアドレスは不正な値です'
        expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
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
          expect {
            click_link_or_button 'アカウント確認メール再送'
          }.to change { ActionMailer::Base.deliveries.size }.by(1)
          mail = ActionMailer::Base.deliveries.last
          url = extract_confirmation_url(mail)
          visit url
          expect(page).to have_content 'アカウント登録が完了しました。プロフィールを登録して下さい。'
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
          expect {
            click_link_or_button 'アカウント確認メール再送'
          }.to change { ActionMailer::Base.deliveries.size }.by(0)
          expect(page).to have_content 'メールアドレスは見つかりませんでした。'
        end
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
        expect(current_path).to eq root_path
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
      click_link_or_button 'クリエーターさんはこちらから'
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

  describe 'プロフィール' do
    let!(:contractor){ create(:contractor, :with_profile) }

    it 'ログインしている受注者は自身のプロフィールを表示でき、プロフィールを編集できること' do
      login_as contractor
      click_link_or_button 'プロフィール'
      # リンクからプロフィールページに遷移すること
      expect(current_path).to eq contractor_profile_path(contractor)
      # すでに登録している情報が表示されていること
      expect(page).to have_content contractor.name
      image_url = contractor.image
      expect(page).to have_css("img[src='#{image_url}']")
      expect(page).to have_content contractor.public_relations
      expect(page).to have_content contractor.portfolio
      expect(page).to have_content contractor.study_period
      click_link_or_button 'プロフィール編集'
      # プロフィール編集ページに遷移できること
      expect(current_path).to eq edit_contractor_profile_path(contractor)
      fill_in 'お名前', with: 'テスト太郎'
      update_image_url = Rails.root.join('spec/files/after_test_avator.png').to_s
      attach_file 'プロフィール画像',  update_image_url
      fill_in '自己PR', with: '初めましてテスト太郎です。よろしくお願いします。'
      fill_in 'ポートフォリオURL', with: 'https://bartell-toy.test/lanita'
      select '１年以上', from: '勉強期間'
      click_link_or_button '登録'
      # 編集後プロフィールページに正しく遷移すること
      expect(page).to have_content 'プロフィール登録が完了しました'
      expect(current_path).to eq contractor_profile_path(contractor)
      # プロフィールページに編集内容が反映されていること
      expect(page).to have_content 'テスト太郎'
      expect(page).to have_css("img[src*='#{File.basename(update_image_url)}']")
      expect(page).to have_content '初めましてテスト太郎です。よろしくお願いします。'
      expect(page).to have_content 'https://bartell-toy.test/lanita'
      expect(page).to have_content '１年以上'
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

    let!(:contractor){ create(:contractor) }

    context 'メールアドレスとパスワードを更新する場合' do
      it '正しい新しいパスワード、現在のパスワードを入力すれば成功すること' do
        login_as contractor
        visit root_path
        click_link_or_button 'アカウント'
        # アカウント編集ページに遷移すること
        expect(current_path).to eq edit_contractor_registration_path(contractor)
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
        expect(page).to have_content 'アカウント登録が完了しました。プロフィールを登録して下さい。'
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
        login_as contractor
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
        login_as contractor
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
        login_as contractor
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
        expect(page).to have_content 'アカウント登録が完了しました。プロフィールを登録して下さい。'
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
        expect {
          click_link_or_button 'パスワード再設定メールを送信'
        }.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
        expect(current_path).to eq new_contractor_session_path
        mail = ActionMailer::Base.deliveries.last
        url = extract_confirmation_url(mail)
        visit url
        expect(current_path).to eq edit_contractor_password_path
        fill_in '新しいパスワード', with: 'newpassword'
        fill_in 'パスワード（確認用）', with: 'newpassword'
        click_link_or_button '登録する'
        expect(current_path).to eq root_path
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
  end

  describe '退会' do

    let!(:contractor){ create(:contractor) }

    it 'ログインしているユーザーは退会できること', :js  do
      login_as contractor
      visit root_path
      click_link_or_button 'アカウント'
      click_link_or_button '退会する'
      expect do
        expect(page.accept_confirm).to eq 'アカウント情報が削除されます。本当に退会しますか？'
        expect(page).to have_content 'アカウントを削除しました'
      end.to change(Contractor, :count).by(-1)
    end
  end

end
