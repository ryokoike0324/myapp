require 'rails_helper'

RSpec.describe 'お問い合わせ' do
  before do
    ActionMailer::Base.deliveries.clear
  end

  context '正しい値を入力した場合' do
    scenario 'お問い合わせが成功すること' do
      visit root_path
      click_link_or_button 'お問い合わせ'
      # お問い合わせページに遷移できる
      expect(current_path).to eq new_contact_path
      # メールが送信されている
      fill_in 'お名前', with: 'ゲスト'
      fill_in 'メールアドレス', with: 'guest@gmail.com'
      fill_in '件名', with: 'お問い合わせテストの件名'
      fill_in 'お問い合わせ内容', with: 'お問い合わせテストのメッセージ'
      click_link_or_button '入力内容確認'
      # 入力内容確認ページへ遷移している
      expect(current_path).to eq confirm_contacts_path
      # 確認ページに入力した内容が表示されていること
      expect(page).to have_content 'ゲスト'
      expect(page).to have_content 'guest@gmail.com'
      expect(page).to have_content 'お問い合わせテストの件名'
      expect(page).to have_content 'お問い合わせテストのメッセージ'
      # 確認ページに送信ボタンが表示されていること
      expect(page).to have_button '送信'
      # 確認ページに内容を修正するボタンが表示されていること
      expect(page).to have_button '内容を修正する'
      # メールが１件送信されていること
      expect do
        click_link_or_button '送信'
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(current_path).to eq done_contacts_path
      expect(page).to have_content 'お問い合わせが完了致しました。'
    end
  end

  context '不正な値を入力した場合' do
    it 'お問い合わせに失敗すること' do
      visit new_contact_path
      # メールが送信されていないこと
      expect do
        fill_in 'お名前', with: nil
        fill_in 'メールアドレス', with: nil
        fill_in '件名', with: nil
        fill_in 'お問い合わせ内容', with: nil
        click_link_or_button '入力内容確認'
      end.to change { ActionMailer::Base.deliveries.size }.by(0)
      expect(current_path).to eq confirm_contacts_path
      # エラーメッセージが表示されていること
      expect(page).to have_content 'お名前を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content '件名を入力してください'
      expect(page).to have_content 'お問い合わせ内容を入力してください'
      # 入力内容確認ページに「送信」ボタンが表示されていないこと
      expect(page).to have_no_button '送信'
    end
  end

  context '確認ページから内容を修正する場合' do
    it '修正内容が反映され、お問い合わせに成功すること' do
      visit new_contact_path
      fill_in 'お名前', with: 'ゲスト'
      fill_in 'メールアドレス', with: 'guest@gmail.com'
      fill_in '件名', with: 'お問い合わせテストの件名'
      fill_in 'お問い合わせ内容', with: 'お問い合わせテストのメッセージ'
      click_link_or_button '入力内容確認'
      # 確認ページを更新しても正しく内容が反映されている
      visit current_path
      expect(current_path).to eq confirm_contacts_path
      expect(page).to have_content 'ゲスト'
      expect(page).to have_content 'guest@gmail.com'
      expect(page).to have_content 'お問い合わせテストの件名'
      expect(page).to have_content 'お問い合わせテストのメッセージ'
      click_link_or_button '内容を修正する'
      expect(current_path).to eq back_contacts_path
      # 入力フィールドに正しい値が表示されている
      expect(page).to have_field 'お名前', with: 'ゲスト'
      expect(page).to have_field 'メールアドレス', with: 'guest@gmail.com'
      expect(page).to have_field '件名', with: 'お問い合わせテストの件名'
      expect(page).to have_field 'お問い合わせ内容', with: 'お問い合わせテストのメッセージ'
      # ページを更新しても正しく内容が反映されている
      visit current_path
      expect(page).to have_content 'お問い合わせ'
      expect(page).to have_field 'お名前', with: 'ゲスト'
      fill_in 'お名前', with: '修正太郎'
      fill_in 'メールアドレス', with: 'again-guest@gmail.com'
      fill_in '件名', with: '修正の件名'
      fill_in 'お問い合わせ内容', with: '１２３４修正修正修正のメッセージ'
      click_link_or_button '入力内容確認'
      # 内容を修正しても正しく値が入力されている
      expect(page).to have_content '修正太郎'
      expect(page).to have_content 'again-guest@gmail.com'
      expect(page).to have_content '修正の件名'
      expect(page).to have_content '１２３４修正修正修正のメッセージ'
      # お問い合わせに成功すること
      expect do
        click_link_or_button '送信'
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(current_path).to eq done_contacts_path
      expect(page).to have_content 'お問い合わせが完了致しました。'
    end
  end

end
