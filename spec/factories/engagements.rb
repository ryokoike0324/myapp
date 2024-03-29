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
FactoryBot.define do
  factory :engagement do
    client { nil }
    contractor { nil }
  end
end
