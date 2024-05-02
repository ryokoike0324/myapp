# == Schema Information
#
# Table name: engagements
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contractor_id :bigint           not null
#  request_id    :bigint           not null
#
# Indexes
#
#  index_engagements_on_contractor_id  (contractor_id)
#  index_engagements_on_request_id     (request_id)
#
# Foreign Keys
#
#  fk_rails_...  (contractor_id => contractors.id)
#  fk_rails_...  (request_id => requests.id)
#
require 'rails_helper'

RSpec.describe Engagement do
  describe 'EventNotifierモジュール' do
    let(:contractor) { create(:contractor) }
    let(:client) { create(:client) }
    let(:request) { create(:request, client:) }
    let(:engagement) { build(:engagement, contractor:, request:) }

    describe 'after_create_commitコールバック' do

      # NotificationJobにperform_laterメソッドが呼ばれることを許可
      # 「呼び出されているかどうか」のみを確認するので、モックを使う
      before do
        allow(NotificationJob).to receive(:perform_later)
        engagement.save
      end

      it 'enqueue_notification_job(バックグラウンドで通知)が実行される' do
        # saveの後に何が実行されたか確認している
        # engagementを登録した後に、NotificationJobがperform_laterメソッドを受け取ったはずである
        # その時にwith内の引数が渡されているはずだよね？
        expect(NotificationJob).to have_received(:perform_later).with(
          # withによってperform_laterメソッドの引数を渡している
          engagement,
          engagement.contractor,
          engagement.request.client
        )
      end
    end

    describe 'determine_recipientメソッド' do
      it 'contractorオブジェクトが返される' do
        expect(engagement.determine_recipient).to eq(contractor)
      end
    end

    describe 'determine_senderメソッド' do
      it 'clientオブジェクトが返される' do
        expect(engagement.determine_sender).to eq(client)
      end
    end

  end
end
