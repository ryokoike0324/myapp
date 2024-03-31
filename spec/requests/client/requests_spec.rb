require 'rails_helper'

RSpec.describe 'Client::RequestsController' do
  describe 'redirect_if_request_existsフィルタ' do

    context 'requestを登録していないclientユーザーの場合' do
      let!(:client){ create(:client) }

      it 'requests#newテンプレートにアクセスできること' do
        sign_in client
        get new_clients_request_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'requestを登録しているclientユーザーの場合' do
      let!(:request){ create(:request) }

      it 'request/newテンプレートにアクセスできず、request/editへリダイレクトすること' do
        client = request.client
        sign_in client
        get new_clients_request_path
        expect(response).to redirect_to(edit_clients_request_path)
      end
    end
  end

  describe 'redirect_if_have_no_requestフィルタ' do

    context 'requestを登録しているclientユーザーの場合' do
      let!(:request){ create(:request) }

      it 'requests#editにアクセスできること' do
        client = request.client
        sign_in client
        get edit_clients_request_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'requestを登録していないclientユーザーの場合' do
      let!(:client){ create(:client) }

      it 'request#editにアクセスできず、request#newへリダイレクトすること' do
        sign_in client
        get edit_clients_request_path
        expect(response).to redirect_to(new_clients_request_path)
      end
    end
  end


end
