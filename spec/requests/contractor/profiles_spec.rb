require 'rails_helper'

RSpec.describe 'Contractor::ProfilesController' do
  describe 'matching_login_contractorフィルタ' do
    let!(:contractor) { create(:contractor) }
    let!(:other_contractor) { create(:contractor) }

    context '他のユーザーのプロフィール編集ページにアクセスしようとした場合' do
      it 'アクセスできずトップページへリダイレクトすること' do
        sign_in contractor
        get edit_contractor_profile_path(other_contractor)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
