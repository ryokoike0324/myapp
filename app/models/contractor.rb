class Contractor < ApplicationRecord
  has_one_attached :image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def self.guest
    find_or_create_by!(email: 'guest-contractor@example.com') do |contractor|
      contractor.password = SecureRandom.urlsafe_base64
      contractor.name = 'ゲスト受注者'
      contractor.confirmed_at = Time.zone.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， contractor.name = "ゲスト" なども必要
    end
  end
end
