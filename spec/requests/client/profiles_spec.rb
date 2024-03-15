require 'rails_helper'

RSpec.describe 'Client::ProfilesController' do
  describe 'matching_login_clientフィルタ' do
    let!(:client) { create(:client) }
    let!(:other_client) { create(:client) }

    context '他のユーザーのプロフィール編集ページにアクセスしようとした場合' do
      it 'アクセスできずトップページへリダイレクトすること' do
        sign_in client
        get edit_client_profile_path(other_client)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
