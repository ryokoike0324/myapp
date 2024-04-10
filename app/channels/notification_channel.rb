class NotificationChannel < ApplicationCable::Channel
  def subscribed
    # stream_fromにより特定のストリームにコンシューマーをつなげる（配信を受け取れるようにする）
    # ユーザーごとにそれぞれの別の通知を送る必要があるため、current_user.idによってストリームを識別している
    # connection.rbのidentified_byで指定したメソッドがチャネル側で使用できる
    stream_from "#{user_type}_user_#{current_user.id}_notification_channel"
    # stream_from "hoge"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
