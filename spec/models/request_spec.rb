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
  describe 'validates' do
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

  describe 'scope' do
    let!(:first_request){ create(:request, created_at: 1.day.ago, deadline: 2.days.from_now, delivery_date: 5.days.from_now) }
    let!(:second_request){ create(:request, created_at: 2.days.ago, deadline: 3.days.from_now, delivery_date: 4.days.from_now) }
    let!(:third_request){ create(:request, created_at: 3.days.ago, deadline: 1.day.from_now, delivery_date: 6.days.from_now) }

    describe 'latest' do
      it 'created_atが新しい日時順のコレクションが返されること' do
        expect(described_class.latest).to eq([first_request, second_request, third_request])
      end
    end

    describe 'old' do
      it 'created_atが古い日時順のコレクションが返されること' do
        expect(described_class.old).to eq([third_request, second_request, first_request])
      end
    end

    describe 'deadline' do
      it '締切日(deadline)が近い順のコレクションが返されること' do
        expect(described_class.until_deadline).to eq([third_request, first_request, second_request])
      end
    end

    describe 'delivery_date' do
      it '納期(delivery_date)が近い順のコレクションが返されること' do
        expect(described_class.until_delivery_date).to eq([second_request, first_request, third_request])
      end
    end
  end
end
