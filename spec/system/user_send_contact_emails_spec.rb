require 'rails_helper'

RSpec.describe 'お問い合わせ', type: :system do
  context '正しい値を入力した場合' do
    before do
      visit new_contact_path
      fill_in 'お名前', with: 'ゲスト'
      fill_in 'メールアドレス', with: 'guest@gmail.com'
      fill_in '件名', with: 'お問い合わせテストの件名'
      fill_in 'メッセージ', with: 'お問い合わせテストのメッセージ'
      click_link_or_button '入力内容確認'
    end

    it '入力内容確認ページへ遷移していること' do
      expect(current_path).to eq confirm_contacts_path
    end

    it '確認ページに入力した内容が表示されていること' do
      expect(page).to have_content 'ゲスト'
      expect(page).to have_content 'guest@gmail.com'
      expect(page).to have_content 'お問い合わせテストの件名'
      expect(page).to have_content 'お問い合わせテストのメッセージ'
    end

    it '確認ページに送信ボタンが表示されていること' do
      expect(page).to have_button '送信'
    end

    it '確認ページに入力画面に戻るボタンが表示されていること' do
      expect(page).to have_button '入力画面に戻る'
    end

    it '送信ボタンをクリックするとお問い合わせが完了すること' do
      click_link_or_button '送信'
      expect(current_path).to eq done_contacts_path
      expect(page).to have_content 'お問い合わせありがとうございました。'
    end

    it '確認画面からお問い合わせ画面に戻れること' do
      click_link_or_button '入力画面に戻る'
      expect(current_path).to eq back_contacts_path
      expect(page).to have_field 'お名前', with: 'ゲスト'
      expect(page).to have_field 'メールアドレス', with: 'guest@gmail.com'
      expect(page).to have_field '件名', with: 'お問い合わせテストの件名'
      expect(page).to have_field 'メッセージ', with: 'お問い合わせテストのメッセージ'
    end
  end
end
