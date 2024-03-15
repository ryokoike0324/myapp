require 'rails_helper'

RSpec.describe '受注者' do

  describe '退会' do

    let!(:contractor){ create(:contractor) }

    it 'ログインしているユーザーは退会できること', :js  do
      log_in_as contractor
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
