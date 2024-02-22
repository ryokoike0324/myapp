require 'rails_helper'

RSpec.describe "ContractorSignUp", type: :system do
  let(:contractor){ build(:contractor) }

  scenario '受注者が正常にユーザー登録できること' do
    visit root_path
    click_link_or_button '新規登録'
    click_link_or_button '受注者登録'
    fill_in 'Email', with: contractor.email
    fill_in 'Password', with: contractor.password
    fill_in 'Password confirmation', with: contractor.password
    click_link_or_button '受注者アカウント登録'
    expect(page).to have_content 'アカウント登録が完了しました'
    expect(current_path).to eq privacy_path
  end
end
