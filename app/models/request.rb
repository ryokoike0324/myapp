class Request < ApplicationRecord
  belongs_to :client_id
  belongs_to :contractor_id
end
