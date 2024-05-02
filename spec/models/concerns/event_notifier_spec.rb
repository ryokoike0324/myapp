# determine_recipientとdetermine_senderがエラーを吐き出すことを確認するためだけ
# determine_recipientとdetermine_senderメソッドをオーバーライドしないダミーを作る
require 'rails_helper'
# 一時的なサブクラスを作成
class TestRequest < Request
  include EventNotifier
end

class TestRequestWithRecipient < TestRequest
  def determine_recipient
    FactoryBot.create(:client)
  end
end

class TestRequestWithSender < TestRequest
  def determine_sender
    FactoryBot.create(:contractor)
  end
end

RSpec.describe EventNotifier do

  context 'determine_recipientとdetermine_senderをオーバーライドしている場合' do
    let(:request) { create(:request) }
    let(:client) { request.client }
    let(:contractor) { create(:contractor) }
    let(:engagement) { create(:engagement, contractor_id: contractor.id, request_id: request.id) }

    before do
      allow(NotificationJob).to receive(:perform_later)
    end

    it 'enqueue_notification_jobが実行される' do
      # NotificationJobが適切な引数で呼び出されることを確認
      engagement.save
      expect(NotificationJob).to have_received(:perform_later).with(
        engagement,
        instance_of(Contractor),
        instance_of(Client)
        )
      # NotificationJobにperform_laterが呼ばれるはずだよね、次のメソッドを実行したら
      # 期待する振る舞いを先に定義することで、テストの意図を明確にし、どのような結果を確認しようとしているのかをはっきりとさせる
    end
  end

  context 'determine_recipientとdetermine_senderどちらもオーバーライドしていない場合' do
    let(:test_request) { TestRequest.new }

    it 'NotImplementedErrorが発生する' do
      expect { test_request.send(:enqueue_notification_job) }.to raise_error(NotImplementedError)
    end
  end

  context 'determine_recipientだけオーバーライドしている場合' do
    let(:test_request) { TestRequestWithRecipient.new }

    it 'NotImplementedErrorが発生する' do
      expect { test_request.send(:enqueue_notification_job) }.to raise_error(NotImplementedError)
    end
  end

  context 'determine_senderだけオーバーライドしている場合' do
    let(:test_request) { TestRequestWithSender.new }

    it 'NotImplementedErrorが発生する' do
      expect { test_request.send(:enqueue_notification_job) }.to raise_error(NotImplementedError)
    end
  end


  # it 'enqueue_notification_jobを呼び出すとNotificationJobがキューに追加される' do
  #   # after_create_commitを擬似的に表現している
  #   test_request.save
  #   expect(NotificationJob).to have_received(:perform_later).with(test_request, 'recipient', 'sender')
  # end
end
