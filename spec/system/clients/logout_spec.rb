require 'rails_helper'

RSpec.describe '発注者' do


  describe 'ログアウト' do
    let!(:client){ create(:client) }

    it 'ログインしているユーザーはログアウトできること' do
      log_in_as client
      click_link_or_button 'ログアウト'
      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_link 'ログイン'
      expect(current_path).to eq root_path

    end
  end
end
