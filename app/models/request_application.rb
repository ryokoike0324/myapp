# == Schema Information
#
# Table name: request_applications
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contractor_id :bigint           not null
#  request_id    :bigint           not null
#
# Indexes
#
#  index_request_applications_on_contractor_id                 (contractor_id)
#  index_request_applications_on_contractor_id_and_request_id  (contractor_id,request_id) UNIQUE
#  index_request_applications_on_request_id                    (request_id)
#
# Foreign Keys
#
#  fk_rails_...  (contractor_id => contractors.id)
#  fk_rails_...  (request_id => requests.id) ON DELETE => cascade
#
class RequestApplication < ApplicationRecord
  # 仕事に対する応募なので、発注者(client)へ送る
  include EventNotifier

  has_one :notification, as: :event, dependent: :destroy
  belongs_to :contractor
  belongs_to :request

  # scopeを付けない場合,テーブル全体で一つの名前のラベル名しか保存できません
  # contractor_id と request_id の組み合わせがユニーク（一意）であることを保証
  # 1人のユーザーは1つのrequestに対して１回しか応募できない（解除しない限り）
  validates :contractor_id, uniqueness: { scope: :request_id }

  private
  # EventNotifier内で必要
  def determine_recipient
    request.client
  end

  def determine_sender
    contractor
  end

end
