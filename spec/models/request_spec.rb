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
#
# Indexes
#
#  index_requests_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
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
      expect(request.errors[:description]).to include('依頼内容を入力してください')
    end

    it 'delivery_dateがないと登録できない' do
      request.delivery_date = nil
      request.valid?
      expect(request.errors[:delivery_date]).to include('納期を入力してください')
    end

    it 'deadlineがないと登録できない' do
      request.deadline = nil
      request.valid?
      expect(request.errors[:deadline]).to include('募集締切を入力してください')
    end

    it 'titleがないと登録できない' do
      request.title = nil
      request.valid?
      expect(request.errors[:title]).to include('タイトルを入力してください')
    end

    it 'deadline_must_be_in_the_future(募集締切が明日以降の日付であること)' do
      request.deadline = Time.zone.today
      expect(request).not_to be_valid
      expect(request.errors[:deadline]).to include('明日以降の日付をご入力ください。')
    end

    it 'delivery_date_must_be_after_deadline(希望納期が募集締切より後の日付であること)' do
      request.deadline = 1.week.from_now
      request.delivery_date = 1.week.from_now - 1.day
      expect(request).not_to be_valid
      expect(request.errors[:delivery_date]).to include('募集締切日より後の日付をご入力ください。')
    end

    it 'deadline(募集締切)とdelivery_date(希望納期)が両方有効な場合に有効であること' do
      request.deadline = 1.week.from_now
      request.delivery_date = 2.weeks.from_now
      expect(request).to be_valid
    end
  end

  describe 'scope' do
    let!(:engaged_contractor){ create(:contractor) }
    let!(:engaged_request){ create(:request) }
    let!(:unengaged_request){ create(:request) }

    describe 'unengaged' do
      it '未契約のRequestのコレクションが返されること' do
        create(:engagement, request: engaged_request, contractor: engaged_contractor)
        # unengaged スコープを呼び出し、unengaged_requestのみが含まれることを確認
        expect(described_class.unengaged).to include(unengaged_request)
        expect(described_class.unengaged).not_to include(engaged_request)
      end
    end
  end

  describe 'instance method' do

    describe 'days_left' do

      it '募集締切日までの残りの日数を返すこと' do
        request = create(:request, deadline: Time.zone.today + 5.days)
        expect(request.days_left).to eq 5
      end
    end

    describe 'deadline_passed?' do

      context '募集締切を過ぎた場合' do

        it 'trueを返すこと' do
          request = build(:request, deadline: Time.zone.today - 1.day)
          request.save(validate: false)
          expect(request.deadline_passed?).to be true
        end
      end

      context '募集締切を過ぎていない場合' do

        it 'falseを返すこと' do
          request = create(:request, deadline: Time.zone.today + 1.day)
          expect(request.deadline_passed?).to be false
        end
      end
    end
  end

end
