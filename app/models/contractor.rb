# == Schema Information
#
# Table name: contractors
#
#  id                     :bigint           not null, primary key
#  applied                :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  contracted             :boolean          default(FALSE), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  image                  :string(255)
#  name                   :string(255)
#  portfolio              :string(255)
#  public_relations       :text(65535)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  study_period           :integer          default("３ヶ月未満"), not null
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_contractors_on_email                 (email) UNIQUE
#  index_contractors_on_reset_password_token  (reset_password_token) UNIQUE
#
class Contractor < ApplicationRecord
  enum study_period: { ３ヶ月未満: 0, ６ヶ月未満: 1, １年未満: 2, １年以上: 3 }
  mount_uploader :image, ContractorAvatorUploader
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
