require 'rails_helper'

RSpec.describe RequestApplication do
  # contractor_idとrequest_idの組み合わせの一意性をテスト
  describe 'バリデーション' do
    let!(:contractor) { create(:contractor) }
    let!(:request) { create(:request) }
    # contractor: contractor<=このようなにkeyとvalueが同じ場合、以下のように省略した書き方をrubocopでは推奨される
    let!(:first_application) { create(:request_application, contractor:, request:) }

    context '新たに申し込みするとき' do
      it '既に登録されているcontractorとrequestの組み合わせは無効であること' do
        new_application = build(:request_application, contractor:, request:)
        expect(new_application).not_to be_valid
        expect(new_application.errors[:contractor_id]).to include('既にこのお仕事に申し込んでいます')
      end

      it 'まだ登録されていないcontractorとrequestの組み合わせは有効であること' do
        different_request = create(:request)
        valid_application = build(:request_application, contractor:, request: different_request)
        expect(valid_application).to be_valid
      end
    end
  end
end
