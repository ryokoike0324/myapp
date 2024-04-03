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
  # 多数の応募者を持つ
  has_many :request_applications, dependent: :destroy
  has_many :applicants, through: :request_applications, source: :contractor
  has_many :favorites, dependent: :destroy
  has_many :likes, through: :favorites, source: :contractor
  # 仕事を発注した発注者は１人
  belongs_to :client

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :until_deadline, -> { order(deadline: :asc) }
  scope :until_delivery_date, -> { order(delivery_date: :asc) }
  # 各Requestが持つ応募の数(request_applications)をカウントする
  scope :with_applicants_count, lambda {
    # request_applicationsテーブルにある各request_idに対応するレコードの数をカウントし、その結果をapplicants_countという名前で取得
    select('requests.*, COUNT(request_applications.id) AS applicants_count')
      # ON以下の条件で対応するrequestsテーブルとrequest_applicationsテーブルのレコードを結合してね
      .joins('LEFT JOIN request_applications ON request_applications.request_id = requests.id')
      # requestsテーブルのidカラムの値に基づいてグループ化
      # 各Requestに対するRequestApplicationの数が個別にカウントされ、applicants_countとして返されます
      .group('requests.id')
  }
  # カウントされた応募者数に基づき、降順Requestのコレクションを並び替える
  scope :applicants_order, lambda {
    with_applicants_count.order('applicants_count DESC')
  }
  scope :with_likes_count, lambda {
    select('requests.*, COUNT(favorites.id) AS likes_count')
      .joins('LEFT JOIN favorites ON favorites.request_id = requests.id')
      .group('requests.id')
  }

  scope :likes_order, lambda {
    with_likes_count.order('likes_count DESC')
  }

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

    # :must_be_in_the_future => i18nによるエラーメッセージ(config/locals/models/request)
    errors.add(:deadline, :must_be_in_the_future) if deadline <= Time.zone.today
  end

  # delivery_dateがdeadlineより後の日付であることを確認するバリデーション
  def delivery_date_must_be_after_deadline
    return if delivery_date.blank? || deadline.blank?

    # :must_be_after_deadline => i18nによるエラーメッセージ(config/locals/models/request)
    errors.add(:delivery_date, :must_be_after_deadline) if delivery_date <= deadline
  end
end
