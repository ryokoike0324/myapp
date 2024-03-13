require 'rails_helper'

RSpec.describe 'requests_controller' do
  describe 'newアクションに対するredirect_if_request_existsフィルタ' do

    context 'requestを登録していないclientユーザーの場合' do
      let!(:client){ create(:client) }

      it 'request/newテンプレートにアクセスできること' do
        sign_in client
        get new_request_path(client)
        expect(response).to have_http_status(:success)
      end
    end

    context 'requestを登録しているclientユーザーの場合' do
      let!(:request){ create(:request) }

      it 'request/newテンプレートにアクセスできず、request/editへリダイレクトすること' do
        client = request.client
        sign_in client
        get new_request_path(client)
        expect(response).to redirect_to(edit_request_path(request))
      end
    end
  end


end
