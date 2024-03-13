# == Schema Information
#
# Table name: requests
#
#  id            :bigint           not null, primary key
#  deadline      :datetime         not null
#  delivery_date :datetime         not null
#  description   :text(65535)      not null
#  title         :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  client_id     :bigint           not null
#  contractor_id :bigint
#
# Indexes
#
#  index_requests_on_client_id      (client_id)
#  index_requests_on_contractor_id  (contractor_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (contractor_id => contractors.id)
#
require 'rails_helper'

RSpec.describe Request do
  describe 'バリデーション' do
    let(:request){ build(:request) }

    it 'title,description,deadline,delivery_dateが存在すれば登録できる' do
      expect(request).to be_valid
    end

    it 'descriptionがないと登録できない' do
      request.description = nil
      request.valid?
      expect(request.errors[:description]).to include('を入力してください')
    end

    it 'delivery_dateがないと登録できない' do
      request.delivery_date = nil
      request.valid?
      expect(request.errors[:delivery_date]).to include('を入力してください')
    end

    it 'deadlineがないと登録できない' do
      request.deadline = nil
      request.valid?
      expect(request.errors[:deadline]).to include('を入力してください')
    end

    it 'titleがないと登録できない' do
      request.title = nil
      request.valid?
      expect(request.errors[:title]).to include('を入力してください')
    end
  end
end
