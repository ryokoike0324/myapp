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
class Request < ApplicationRecord
  has_many :request_applications, dependent: :destroy
  has_many :applicants, through: :request_applications, source: :contractor
  belongs_to :client

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :until_deadline, -> { order(deadline: :asc) }
  scope :until_delivery_date, -> { order(delivery_date: :asc) }

  validates :title, presence: true
  validates :description, presence: true
  validates :deadline, presence: true
  validates :delivery_date, presence: true
  # カスタムバリデーション
  validate :deadline_must_be_in_the_future
  validate :delivery_date_must_be_after_deadline

  # 募集締切までの日数を返す
  def days_left
    (deadline.to_date - Time.zone.today).to_i
  end

  # 募集締切を過ぎたかどうか
  def deadline_passed?
    (deadline.to_date - Time.zone.today).to_i < 0
  end

  private

  # deadlineが明日以降の日付であることを確認するバリデーション
  def deadline_must_be_in_the_future
    # 早期リターンー不要な処理をスキップすることでコードの効率性を向上させたり、不正な状態でのエラーを防ぐ
    return if deadline.blank?

    errors.add(:deadline, '明日以降の日付をご入力ください。') if deadline <= Time.zone.today
  end

  # delivery_dateがdeadlineより後の日付であることを確認するバリデーション
  def delivery_date_must_be_after_deadline
    return if delivery_date.blank? || deadline.blank?

    errors.add(:delivery_date, 'は募集締切日より後の日付をご入力ください。') if delivery_date <= deadline
  end
end
