require 'rails_helper'

RSpec.describe 'UserSignUp', type: :system do
  let(:client){ build(:client) }

  scenario '発注者が正常にユーザー登録できること' do
    visit root_path
    click_link_or_button '新規登録'
    click_link_or_button '発注者登録'
    fill_in 'Email', with: client.email
    fill_in 'Password', with: client.password
    fill_in 'Password confirmation', with: client.password
    click_link_or_button '発注者アカウント登録'
    expect(page).to have_content 'アカウント登録が完了しました'
    expect(current_path).to eq terms_path
  end
end
