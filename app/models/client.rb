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
  has_one :request, dependent: :destroy
  enum industry: { 飲食: 0, 製造: 1, IT: 2, 建築: 3, サービス: 4, その他: 5 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def self.guest
    find_or_create_by!(email: 'guest-client@example.com') do |client|
      client.password = SecureRandom.urlsafe_base64
      client.name = 'ゲスト発注者'
      client.confirmed_at = Time.zone.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， client.name = 'ゲスト' なども必要
    end
  end
end
