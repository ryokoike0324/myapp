require 'rails_helper'

RSpec.describe "依頼内容" do
  describe 'お仕事登録' do
    let!(:client){ create(:client) }
    let(:request){ build(:request) }

    context '正しい値を入力した場合' do
      it 'お仕事登録が成功すること' do
        login_as client
        visit new_request_path
        p request
        expect do
          fill_in 'お仕事タイトル', with: request.title
          fill_in '依頼内容', with: request.description
          fill_in '募集締切', with: request.deadline
          fill_in '納期', with: request.delivery_date
          click_link_or_button('登録')
        end.to change(Request, :count).by(1)
      end
    end
  end
end
