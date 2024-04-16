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
  # 多数の応募者、お気に入りを持つ
  has_many :request_applications, dependent: :destroy
  has_many :applicants, through: :request_applications, source: :contractor
  has_many :favorites, dependent: :destroy
  has_many :likes, through: :favorites, source: :contractor
  has_one :engagement, dependent: :destroy
  # 仕事を発注した発注者は１人
  belongs_to :client

  # 未契約のお仕事(request)を返す
  scope :unengaged, lambda {
    joins('LEFT OUTER JOIN engagements ON engagements.request_id = requests.id')
      .where(engagements: { id: nil })
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

  # 応募者数に基づくソート
  ransacker :applicants_count_sort do
    Arel.sql('(
      SELECT COUNT(request_applications.id)
      FROM request_applications
      WHERE request_applications.request_id = requests.id)')
  end

  # お気に入り数に基づくソート
  ransacker :likes_count_sort do
    Arel.sql('(
      SELECT COUNT(favorites.id)
      FROM favorites
      WHERE favorites.request_id = requests.id)')
  end

  # Ransackで検索にかけるホワイトリスト
  # 引数の前に_をつけると引数がメソッド内で使用されていないことを表示する
  def self.ransackable_attributes(_auth_object = nil)
    %w[title description created_at deadline delivery_date]
  end

  # デフォルトでは、Ransackはすべてのカラムで or 検索を許可しない
  # モデルの特定の関連付けに対して検索（フィルタリング）を許可したり、除外したりすることができる
  # すべての関連付けで検索を許可するとパフォーマンスの問題や意図しない結果を招く可能性があるため
  def self.ransackable_associations(_auth_object = nil)
    %w[client]
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
