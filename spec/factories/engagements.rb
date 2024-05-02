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
FactoryBot.define do
  factory :engagement do
    # { nil }デフォルト値として何も設定しないことを明示
    # つまりclient_id,contractor_id,request_idがデフォルトでnilだよ
    contractor { nil }
    request { nil }
  end
end
