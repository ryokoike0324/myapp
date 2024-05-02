# == Schema Information
#
# Table name: engagements
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contractor_id :bigint           not null
#  request_id    :bigint           not null
#
# Indexes
#
#  index_engagements_on_contractor_id  (contractor_id)
#  index_engagements_on_request_id     (request_id)
#
# Foreign Keys
#
#  fk_rails_...  (contractor_id => contractors.id)
#  fk_rails_...  (request_id => requests.id)
#
class Engagement < ApplicationRecord
  include EventNotifier

  has_one :notification, as: :event, dependent: :destroy
  belongs_to :request
  belongs_to :contractor

  # EventNotifierモジュール内で必要
  # 仕事を依頼する通知なので、受注者(contractor)へ送る
  def determine_recipient
    contractor
  end

  def determine_sender
    request.client
  end
end
