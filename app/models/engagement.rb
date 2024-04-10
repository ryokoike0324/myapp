# == Schema Information
#
# Table name: engagements
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  client_id     :bigint           not null
#  contractor_id :bigint           not null
#
# Indexes
#
#  index_engagements_on_client_id      (client_id)
#  index_engagements_on_contractor_id  (contractor_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (contractor_id => contractors.id)
#
class Engagement < ApplicationRecord
  # 仕事を依頼する通知なので、受注者(contractor)へ送る
  include EventNotifier

  has_one :notification, as: :event, dependent: :destroy
  belongs_to :client
  belongs_to :contractor

  private
  # EventNotifierモジュール内で必要
  def determine_recipient
    contractor
  end

  def determine_sender
    client
  end
end
