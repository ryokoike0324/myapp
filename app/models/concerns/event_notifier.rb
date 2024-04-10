# app/models/concerns/event_notifier.rb
module EventNotifier
  extend ActiveSupport::Concern
  # ActiveSupport::Concernモジュールをクラスメソッド（extend）として使えるように

  # included内のコードは呼び出し元のクラスで実行される
  included do
    # インスタンスがcreateされた（通知すべきイベントが起きた）後通知を送る
    after_create_commit :enqueue_notification_job
  end

  private

  # 通知のオブジェクト生成をバックグラウンドで実行
  def enqueue_notification_job
    # NotificationJobを非同期で実行する
    NotificationJob.perform_later(self, determine_recipient, determine_sender)
  end

  # includeした各モデルでdetermine_recipient(通知を受け取る人)の実装をしてね
  # 絶対必要だから、オーバーライドされてないとエラーを発生させるようにしておく
  def determine_recipient
    raise NotImplementedError, "#{self.class.name}モデル内で#determine_recipientメソッドをオーバーライドして下さい"
  end

  def determine_sender
    raise NotImplementedError, "#{self.class.name}モデル内で#determine_senderメソッドをオーバーライドして下さい"
  end
end
