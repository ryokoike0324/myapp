require 'rails_helper'

RSpec.describe 'お問い合わせ', type: :system do
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
      fill_in 'メッセージ', with: 'お問い合わせテストのメッセージ'
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
      # 確認ページに入力画面に戻るボタンが表示されていること
      expect(page).to have_button '入力画面に戻る'
      # メールが１件送信されていること
      expect do
        click_link_or_button '送信'
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(current_path).to eq done_contacts_path
      expect(page).to have_content 'お問い合わせありがとうございました。'
    end
  end

  context '不正な値を入力した場合' do
    it 'お問い合わせに失敗すること' do
      visit new_contact_path
      # メールが送信されていないこと
      expect{
        fill_in 'お名前', with: nil
        fill_in 'メールアドレス', with: nil
        fill_in '件名', with: nil
        fill_in 'メッセージ', with: nil
        click_link_or_button '入力内容確認'
      }.to change { ActionMailer::Base.deliveries.size }.by(0)
      expect(current_path).to eq confirm_contacts_path
      # エラーメッセージが表示されていること
      expect(page).to have_content 'Nameを入力してください'
      expect(page).to have_content 'Emailを入力してください'
      expect(page).to have_content 'Subjectを入力してください'
      expect(page).to have_content 'Messageを入力してください'
      # 入力内容確認ページに「送信」ボタンが表示されていないこと
      expect(page).to have_no_button '送信'
    end
  end

  it '確認画面からお問い合わせ画面に戻れること' do
    visit new_contact_path
    fill_in 'お名前', with: 'ゲスト'
    fill_in 'メールアドレス', with: 'guest@gmail.com'
    fill_in '件名', with: 'お問い合わせテストの件名'
    fill_in 'メッセージ', with: 'お問い合わせテストのメッセージ'
    click_link_or_button '入力内容確認'
    click_link_or_button '入力画面に戻る'
    expect(current_path).to eq back_contacts_path
    # 入力した値が表示されていること
    expect(page).to have_field 'お名前', with: 'ゲスト'
    expect(page).to have_field 'メールアドレス', with: 'guest@gmail.com'
    expect(page).to have_field '件名', with: 'お問い合わせテストの件名'
    expect(page).to have_field 'メッセージ', with: 'お問い合わせテストのメッセージ'
  end
end
