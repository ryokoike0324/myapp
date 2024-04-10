module Clients::NotificationsHelper
  # タイトルを10文字で切り取り、11文字以上あれば末尾に「...」を追加
  def display_title(notification)
    title = notification.event.request.title
    title.length > 15 ? "#{title.slice(0, 15)}…" : title
  end

  # 通知すべきイベントを発生させた（お気に入り・応募した）受注者の名前を返す
  def event_contractor(notification)
    case notification.event
    when RequestApplication, Favorite
      notification.event.contractor
    else
      ''
    end
  end
end
