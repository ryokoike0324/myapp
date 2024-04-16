# == Schema Information
#
# Table name: clients
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  industry               :integer          default("飲食"), not null
#  name                   :string(255)
#  our_business           :text(65535)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_clients_on_email                 (email) UNIQUE
#  index_clients_on_reset_password_token  (reset_password_token) UNIQUE
#
class Client < ApplicationRecord
  # ポリモーフィックスの関連付け
  has_many :sent_notifications, as: :sender, class_name: 'Notification', dependent: :destroy
  has_many :received_notifications, as: :recipient, class_name: 'Notification', dependent: :destroy
  # 多数の仕事を発注できる
  has_many :requests, dependent: :destroy
  # 各requestが持つengagementの集合を返す
  has_many :engagements, through: :requests
  enum industry: { 飲食: 0, 製造: 1, IT: 2, 建築: 3, サービス: 4, その他: 5 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def self.guest
    guest_client = find_or_create_by!(email: 'guest-client@example.com') do |client|
      client.password = SecureRandom.urlsafe_base64
      client.name = 'ゲスト発注者'
      # Confirmable を使用している場合は必要
      client.confirmed_at = Time.zone.now
      client.our_business = 'ゲスト発注者の事業内容欄です。お好きに編集して下さい。'
    end
    # 既存の関連 Request が存在しない場合にのみ新たに作成
    if guest_client.requests.blank?
      request = guest_client.requests.create(
        title: 'ゲスト発注者のお仕事投稿タイトル',
        description: 'ゲスト発注者のお仕事情報詳細欄です。お好きに編集して下さい。',
        deadline: 1.week.from_now,
        delivery_date: 2.weeks.from_now
      )
      contractors_sample = Contractor.order(Arel.sql('RAND()')).limit(5)
      contractors_sample.each do |contractor|
        # このContractorが既にこのRequestに応募している場合は、ループをスキップする
        next if request.applicants.include?(contractor)

        RequestApplication.create!(
          request:,
          contractor:
        )
      end
    end
    guest_client
  end

  # すべての業種名を配列で返す
  def self.unique_industries
    # pluck：指定されたカラム（ここでは industry）の値だけを配列として返す
    distinct.pluck(:industry)
  end

  # enumのためパラメータを数値に変換する
  def self.enum_ransack_params(params)
    params_dup = params.dup
    # dup メソッドはオブジェクトのシャローコピー（浅いコピー）を作成。元のオブジェクトには影響を与えません
    # 元の params オブジェクトを変更せずに、そのコピーを操作するため
    # 複数の場所で params を参照している場合、一箇所での変更が他の場所に影響を及ぼす可能性
    if params_dup['client_industry_eq']
      # params_dup["client_industry_eq"] が存在する場合、その値を Client.industries マップを使って整数値に変換
      # Client.industriesはenumが提供する機能
      # 各業界名をその対応する整数値にマッピングするハッシュを返します
      # {"飲食"=>0, "製造"=>1, "IT"=>2, "建築"=>3, "サービス"=>4, "その他"=>5}
      industry_value = industries[params_dup['client_industry_eq']]
      params_dup['client_industry_eq'] = industry_value if industry_value
    end
    params_dup
  end

  # Ransackの検索可能なホワイトリストを定義
  # これにより 'industry' が検索可能になる
  def self.ransackable_attributes(_auth_object = nil)
    authorizable_ransackable_attributes & %w[industry]
  end

  # 指定した関連だけ検索対象とすることができる
  # すべての関連付けで検索を許可するとパフォーマンスの問題や意図しない結果を招く可能性があるため
  def self.ransackable_associations(_auth_object = nil)
    authorizable_ransackable_attributes & %w[requests]
  end
end
