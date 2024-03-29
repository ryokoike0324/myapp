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
#  fk_rails_...  (request_id => requests.id)
#
FactoryBot.define do
  factory :request_application do
    contractor
    request
  end
end
