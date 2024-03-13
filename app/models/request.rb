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
#  contractor_id :bigint
#
# Indexes
#
#  index_requests_on_client_id      (client_id)
#  index_requests_on_contractor_id  (contractor_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (contractor_id => contractors.id)
#
class Request < ApplicationRecord
  belongs_to :client

  validates :title, presence: true
  validates :description, presence: true
  validates :deadline, presence: true
  validates :delivery_date, presence: true
end
