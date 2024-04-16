class NotificationJob < ApplicationJob
  queue_as :default

  def perform(event, recipient, sender)
    # Notificationモデルはポリモーフィックス関連のカラム(recipient)を持っているため、
    # recipientにオブジェクトを渡せば内部的に、idとtypeをマッピングしてくれる
    Notification.create!(event:, recipient:, sender:, unread: true)
    # notification_count = Notification.unread.where(recipient:).count

    # Action Cableを使用してリアルタイム通知を送信
    # ActionCable.server.broadcast("#{recipient.class.name}_user_#{recipient.id}_notification_channel", {notification_count:})
    # ActionCable.server.broadcast("hoge", {notification_count:})
  end

end
