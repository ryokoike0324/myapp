# == Schema Information
#
# Table name: favorites
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contractor_id :bigint           not null
#  request_id    :bigint           not null
#
# Indexes
#
#  index_favorites_on_contractor_id  (contractor_id)
#  index_favorites_on_request_id     (request_id)
#
# Foreign Keys
#
#  fk_rails_...  (contractor_id => contractors.id)
#  fk_rails_...  (request_id => requests.id)
#
class Favorite < ApplicationRecord
  # 仕事に対するお気に入りなので、発注者(client)へ送る
  include EventNotifier

  has_one :notification, as: :event, dependent: :destroy
  belongs_to :contractor
  belongs_to :request

  # contractor_id と request_id の組み合わせがユニーク（一意）であることを保証
  # 1人のユーザーは1つのrequestに対して１回しかお気に入りに登録できない（解除しない限り）
  validates :contractor_id, uniqueness: { scope: :request_id }

  private
  # 通知作成のためrecipientとsenderを決めるEventNotifier内で必要
  def determine_recipient
    request.client
  end

  def determine_sender
    contractor
  end
end
