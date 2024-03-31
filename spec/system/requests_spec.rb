require 'rails_helper'

RSpec.describe '依頼内容' do
  describe 'お仕事登録' do
    let!(:client){ create(:client) }
    let(:request){ build(:request) }

    context '正しい値を入力した場合' do
      it 'お仕事登録が成功すること' do
        log_in_as client
        visit new_clients_request_path(client)
        expect do
          fill_in 'お仕事タイトル', with: request.title
          fill_in '依頼内容', with: request.description
          fill_in '募集締切', with: request.deadline
          fill_in '納期', with: request.delivery_date
          click_link_or_button('登録')
        end.to change(Request, :count).by(1)
        expect(current_path).to eq edit_clients_profile_path(client)
      end
    end

    context '不正な値を入力した場合' do
      it 'お仕事登録が失敗すること' do
        log_in_as client
        visit new_clients_request_path(client)
        expect do
          fill_in 'お仕事タイトル', with: nil
          fill_in '依頼内容', with: nil
          fill_in '募集締切', with: nil
          fill_in '納期', with: nil
          click_link_or_button('登録')
        end.to change(Request, :count).by(0)
        expect(current_path).to eq clients_request_path(client)
      end
    end
  end
end
