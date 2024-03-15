require 'rails_helper'

RSpec.describe 'Client::RequestsController' do
  describe 'redirect_if_request_existsフィルタ' do

    context 'requestを登録していないclientユーザーの場合' do
      let!(:client){ create(:client) }

      it 'client/:id/request/newテンプレートにアクセスできること' do
        sign_in client
        get new_client_request_path(client)
        expect(response).to have_http_status(:success)
      end
    end

    context 'requestを登録しているclientユーザーの場合' do
      let!(:request){ create(:request) }

      it 'request/newテンプレートにアクセスできず、request/editへリダイレクトすること' do
        client = request.client
        sign_in client
        get new_client_request_path(client)
        expect(response).to redirect_to(edit_client_request_path(request))
      end
    end
  end

  describe 'editアクションに対するredirect_if_have_no_requestフィルタ' do

    context 'requestを登録しているclientユーザーの場合' do
      let!(:request){ create(:request) }

      it 'request#editにアクセスできること' do
        client = request.client
        sign_in client
        get edit_client_request_path(client)
        expect(response).to have_http_status(:success)
      end
    end

    context 'requestを登録していないclientユーザーの場合' do
      let!(:client){ create(:client) }

      it 'request#editにアクセスできず、request#newへリダイレクトすること' do
        sign_in client
        get edit_client_request_path(client)
        expect(response).to redirect_to(new_client_request_path)
      end
    end
  end


end
