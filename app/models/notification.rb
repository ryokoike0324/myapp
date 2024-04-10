# == Schema Information
#
# Table name: notifications
#
#  id             :bigint           not null, primary key
#  event_type     :string(255)      not null
#  recipient_type :string(255)      not null
#  sender_type    :string(255)      not null
#  unread         :boolean          default(TRUE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  event_id       :bigint           not null
#  recipient_id   :bigint           not null
#  sender_id      :bigint           not null
#
# Indexes
#
#  index_notifications_on_event      (event_type,event_id)
#  index_notifications_on_recipient  (recipient_type,recipient_id)
#  index_notifications_on_sender     (sender_type,sender_id)
#
class Notification < ApplicationRecord
  # 通知の受取人（recipient）に関するポリモーフィック関連（これ書いとくだけで、他の複数のモデルと関連をもてる）
  belongs_to :sender, polymorphic: true
  belongs_to :recipient, polymorphic: true

  # 通知の発生源となるイベント（event）に関するポリモーフィック関連
  belongs_to :event, polymorphic: true

  # 既読・未読の状態を管理するためのスコープ
  scope :unread, -> { where(unread: true) }
  scope :read, -> { where(unread: false) }

  # 通知を既読にするインスタンスメソッド
  def mark_as_read
    update(unread: false)
  end

  # 直近30秒以内に更新されたかどうかを判断するメソッド
  # 一覧表示で全て通知が既読になるため、更新された日時で新しい通知か判別する
  def updated_recently?
    updated_at > 30.seconds.ago
  end

end
