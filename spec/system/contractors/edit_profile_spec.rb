require 'rails_helper'

RSpec.describe '受注者' do

  describe 'プロフィール編集' do
    let!(:contractor){ create(:contractor, :with_profile) }

    it 'ログインしている受注者は自身のプロフィールを表示でき、プロフィールを編集できること' do
      log_in_as contractor
      click_link_or_button 'プロフィール'
      # リンクからプロフィールページに遷移すること
      expect(current_path).to eq edit_contractors_profile_path
      # すでに登録している情報が表示されていること
      expect(page).to have_field 'お名前', with: contractor.name
      image_url = contractor.image
      expect(page).to have_css("img[src='#{image_url}']")
      expect(page).to have_field '自己PR', with: contractor.public_relations
      expect(page).to have_field 'ポートフォリオURL', with: contractor.portfolio
      expect(page).to have_select('勉強期間', selected: contractor.study_period)
      click_link_or_button '登録'
      # Topページに遷移できること
      expect(current_path).to eq root_path
      click_link_or_button 'プロフィール'
      fill_in 'お名前', with: 'テスト太郎'
      update_image_url = Rails.root.join('spec/files/after_test_avator.png').to_s
      attach_file 'プロフィール画像',  update_image_url
      fill_in '自己PR', with: '初めましてテスト太郎です。よろしくお願いします。'
      fill_in 'ポートフォリオURL', with: 'https://bartell-toy.test/lanita'
      select '１年以上', from: '勉強期間'
      click_link_or_button '登録'
      # 編集後プロフィールページに正しく遷移すること
      expect(page).to have_content 'プロフィール登録が完了しました'
      expect(current_path).to eq root_path
      # プロフィールページに編集内容が反映されていること
      click_link_or_button 'プロフィール'
      expect(page).to have_field 'お名前', with: 'テスト太郎'
      expect(page).to have_css("img[src*='#{File.basename(update_image_url)}']")
      expect(page).to have_field '自己PR', with: '初めましてテスト太郎です。よろしくお願いします。'
      expect(page).to have_field 'ポートフォリオURL', with: 'https://bartell-toy.test/lanita'
      expect(page).to have_select('勉強期間', selected: '１年以上')
    end
  end
end
