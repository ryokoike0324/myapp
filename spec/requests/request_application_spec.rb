require 'rails_helper'

RSpec.describe 'RequestApplications' do
  describe 'POST #apply' do
    let(:contractor) { create(:contractor) }
    let(:request) { create(:request) }
    let!(:first_application) { create(:request_application, contractor:, request:) }

    before do
      sign_in contractor
    end

    context '申込に失敗した時' do
      before do
        post apply_request_path(request)
      end

      it '適切にリダイレクトすること' do
        expect(response).to redirect_to(clients_requests_path)
      end

      it 'flashメッセージが登録されていること' do
        expect(flash[:alert]).to eq '申し込みに失敗しました。'
      end
    end
  end
end
