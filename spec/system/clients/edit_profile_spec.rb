require 'rails_helper'

RSpec.describe '発注者' do

  describe 'プロフィール編集' do
    let!(:client){ create(:client, :with_profile) }

    it 'ログインしている発注者は自身のプロフィールを表示でき、プロフィールを編集できること' do
      log_in_as client
      click_link_or_button 'プロフィール'
      # リンクからプロフィールページに遷移すること
      expect(current_path).to eq edit_client_profile_path(client)
      # すでに登録している情報が表示されていること
      expect(page).to have_field '店名・会社名', with: client.name
      expect(page).to have_field '事業内容', with: client.our_business
      expect(page).to have_select('業種', selected: client.industry)
      fill_in '店名・会社名', with: '東京ストリート塩ラーメン'
      fill_in '事業内容', with: '池袋で、美味しい塩ラーメンの店をやっております。'
      select '飲食', from: '業種'
      click_link_or_button '登録'
      # 編集後プロフィールページに正しく遷移すること
      expect(page).to have_content 'プロフィール登録が完了しました'
      expect(current_path).to eq root_path
      # プロフィールページに編集内容が反映されていること
      click_link_or_button 'プロフィール'
      expect(page).to have_field '店名・会社名', with: '東京ストリート塩ラーメン'
      expect(page).to have_field '事業内容', with: '池袋で、美味しい塩ラーメンの店をやっております。'
      expect(page).to have_select('業種', selected: '飲食')
    end
  end
end
